# Secrets Management with agenix

How to manage encrypted secrets across your nixos-config, from development to deployment.

## Overview

**agenix** encrypts secrets using SSH keys and integrates with NixOS/nix-darwin rebuilds. Secrets are:
- Encrypted at rest in your git repo
- Decrypted on rebuild using the host's SSH private key
- Never committed unencrypted

### Key concepts

- **secrets.yaml**: Manifest file listing all secrets and their owners/permissions
- **secrets/*.age**: Individual encrypted secret files (git-committed)
- **SSH key**: Your host's private key used to decrypt secrets during rebuild

---

## Setup: Initial Configuration

### Step 1: Generate SSH key on your host (if needed)

On your NixOS host or macOS machine:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "my-host"
```

You'll use this key's *public* part for encryption and the private part for decryption.

### Step 2: Create shared/secrets/secrets.nix (Master key file)

In the repo root, create `shared/secrets/secrets.nix` to list all SSH public keys that can decrypt secrets:

```bash
mkdir -p shared/secrets
cat > shared/secrets/secrets.nix << 'EOF'
let
  # Add all host/user SSH public keys here
  xavtrav-octantis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...";  # octantis host key
  xavtrav-darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...";    # darwin host key
  
in
{
  "secrets" = [ xavtrav-octantis xavtrav-darwin ];
}
EOF
```

Get each host's public key:
```bash
# On the host
cat ~/.ssh/id_ed25519.pub
```

### Step 3: Initialize agenix in a host directory

```bash
cd hosts/octantis

# Create secrets directory
mkdir -p secrets

# Create a .sops.yaml file (agenix config)
cat > .sops.yaml << 'EOF'
keys:
  - &host ssh-ed25519 <your-host-public-key-here>
creation_rules:
  - path_regex: secrets/.*\.age$
    key_groups:
      - keys:
          - *host
EOF
```

---

## Adding Secrets

### Step 1: Create a secret file

```bash
cd hosts/octantis

# Create a temporary plaintext secret
echo "my-jellyfin-db-password" > secrets/jellyfin_db_password.txt
```

### Step 2: Encrypt with agenix

**Option A: From the host (NixOS/macOS with agenix installed):**

```bash
nix run github:ryantm/agenix -- -e secrets/jellyfin_db_password.age
```

This opens an editor. Paste your secret, save, and it encrypts automatically.

**Option B: From WSL2:**

```bash
# In WSL2 terminal
cd /mnt/c/dev/code/nixos-config/hosts/octantis
nix run github:ryantm/agenix -- -e secrets/jellyfin_db_password.age
```

**Option C: From Windows (manual, not recommended):**

Use a Linux VM or SSH to the host and encrypt there.

### Step 3: Add to secrets.yaml

Edit `hosts/octantis/secrets.yaml`:

```yaml
jellyfin_db_password:
  file = ./secrets/jellyfin_db_password.age
  owner = "jellyfin"
  group = "jellyfin"
  mode = "0440"
```

The file path, owner, group, and mode control where the secret is placed and who can read it.

### Step 4: Use the secret in configuration

In `hosts/octantis/configuration.nix`:

```nix
{
  imports = [ ../../modules/services/jellyfin ];

  services.jellyfin.enable = true;
  # Reference the decrypted secret
  environment.etc."jellyfin/db_password".source = config.age.secrets.jellyfin_db_password.path;
}
```

Or in a module:

```nix
{ config, ... }:

{
  services.jellyfin.environment.DB_PASSWORD = 
    "file://${config.age.secrets.jellyfin_db_password.path}";
}
```

### Step 5: Rebuild (decryption happens automatically)

```bash
cd hosts/octantis
sudo nixos-rebuild switch --flake .
```

agenix automatically decrypts `jellyfin_db_password.age` using your host's SSH private key.

---

## Managing Secrets Across Platforms

### From NixOS host

```bash
cd /etc/nixos/hosts/octantis  # or wherever you cloned the repo

# Edit a secret
nix run github:ryantm/agenix -- -e secrets/jellyfin_db_password.age

# Commit encrypted secret
git add secrets/jellyfin_db_password.age secrets.yaml
git commit -m "Add jellyfin db password"
```

### From macOS (darwin) host

```bash
cd ~/nixos-config/hosts/darwin-mac  # or wherever you cloned

# Install agenix CLI
nix run github:ryantm/agenix -- -e secrets/backup_password.age

# Commit
git add secrets/backup_password.age secrets.yaml
git commit -m "Add backup password"
```

### From WSL2 (Windows dev machine)

**Prerequisite**: Nix installed in WSL2.

```bash
# In WSL2 terminal
cd /mnt/c/dev/code/nixos-config/hosts/octantis

# Edit a secret
nix run github:ryantm/agenix -- -e secrets/jellyfin_db_password.age

# Commit from Windows git
git add secrets/jellyfin_db_password.age secrets.yaml
git commit -m "Add secret"
```

### From Windows (without WSL2)

**Option 1: SSH to the host**
```powershell
# From Windows PowerShell
ssh user@octantis-host
cd /etc/nixos/hosts/octantis
nix run github:ryantm/agenix -- -e secrets/password.age
```

**Option 2: Use a Linux VM or docker container with agenix**

---

## Committing & Distributing Secrets

### What gets committed?

**✅ Commit these:**
- `secrets/*.age` (encrypted files)
- `secrets.yaml` (manifest)
- `.sops.yaml` (encryption configuration)

**❌ Never commit:**
- `secrets/*.txt` (plaintext)
- SSH private keys (`~/.ssh/id_*`)
- Unencrypted environment files

### How do secrets reach your hosts?

1. **Clone the repo:**
   ```bash
   git clone <repo-url> /etc/nixos
   ```

2. **Secrets travel encrypted in git:**
   - `hosts/octantis/secrets/*.age` are in the repo (encrypted)
   - Host's SSH private key stays on the host (never in git)

3. **Rebuild decrypts them:**
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

4. **agenix decrypts using local SSH key:**
   - agenix reads `secrets/*.age` files
   - Uses host's private key (`~/.ssh/id_ed25519`) to decrypt
   - Places decrypted files at paths specified in `secrets.yaml`

### Multi-host secrets

If multiple hosts need the same secret:

```yaml
# shared/secrets/secrets.nix
let
  octantis-key = "ssh-ed25519 AAAA...";
  darwin-key = "ssh-ed25519 BBBB...";
in
{
  "shared_secret" = [ octantis-key darwin-key ];  # Both can decrypt
}
```

Then both hosts can use:
```nix
environment.etc."app/password".source = config.age.secrets.shared_secret.path;
```

---

## Rotating Secrets

### To update an existing secret:

```bash
# Re-edit the encrypted file
nix run github:ryantm/agenix -- -e secrets/jellyfin_db_password.age

# This decrypts, lets you edit, and re-encrypts with the same key
git add secrets/jellyfin_db_password.age
git commit -m "Update jellyfin db password"
```

### To rotate encryption keys (add/remove hosts):

1. Update `shared/secrets/secrets.nix` with new keys
2. Re-encrypt all secrets:
   ```bash
   nix run github:ryantm/agenix -- -r
   ```
3. Commit the newly encrypted files

---

## Troubleshooting

**"agenix: command not found"**
- Install: `nix run github:ryantm/agenix -- --version` (verifies Nix can run it)
- Or add to system packages: `environment.systemPackages = [ agenix ];`

**"SSH key permission denied during rebuild"**
- SSH agent not running: `ssh-add ~/.ssh/id_ed25519`
- Wrong key: Verify `cat ~/.ssh/id_ed25519.pub` matches entry in `shared/secrets/secrets.nix`

**"age: unable to decrypt with any identity"**
- Host's SSH key doesn't match the key used to encrypt
- Verify the secret was encrypted with this host's public key

**"secrets.yaml: not found"**
- Run `agenix -e` to create it in the current directory
- Make sure you're in the host directory (`hosts/octantis/`)

**"Can't decrypt from WSL2"**
- Use absolute path: `/mnt/c/dev/code/nixos-config/...`
- Ensure SSH key is in WSL2: `ls ~/.ssh/id_ed25519`
- Or copy your Windows SSH key: `cp /mnt/c/Users/<user>/.ssh/id_ed25519 ~/.ssh/`

---

## Resources

- [agenix GitHub](https://github.com/ryantm/agenix)
- [Age Encryption](https://github.com/FiloSottile/age)
- [NixOS agenix module docs](https://github.com/ryantm/agenix#readme)
