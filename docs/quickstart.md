# Quickstart Guide

Get your nixos-config running on a new host.

## Part 1: Build a New Host Configuration

### Step 1: Copy the host template

Choose your platform:

**For NixOS (Linux servers/desktops):**
```bash
cd nixos-config
cp -r hosts/octantis hosts/my-nixos-host
```

**For macOS (with nix-darwin):**
```bash
cd nixos-config
cp -r hosts/darwin-mac hosts/my-darwin-host
```

### Step 2: Customize the configuration

#### For NixOS hosts:

Edit `hosts/my-nixos-host/flake.nix`:
```nix
nixosConfigurations.my-nixos-host = nixpkgs.lib.nixosSystem {
  inherit system;
  # ... rest of config
};
```

Edit `hosts/my-nixos-host/configuration.nix`:
```nix
{
  networking.hostName = "my-nixos-host";  # Change hostname
  time.timeZone = "Your/Timezone";        # Set timezone
  
  users.users.username = {                # Add your user
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
```

#### For darwin hosts:

Edit `hosts/my-darwin-host/flake.nix`:
```nix
darwinConfigurations."my-darwin-host" = nix-darwin.lib.darwinSystem {
  # ... update system arch as needed (aarch64-darwin for M1/M2, x86_64-darwin for Intel)
};
```

Edit `hosts/my-darwin-host/configuration.nix`:
```nix
{
  system.defaults.dock.autohide = true;
  # ... customize macOS settings
}
```

### Step 3: Customize home-manager

Edit `hosts/my-host/home-configuration.nix`:
```nix
{
  home.username = "your-username";
  home.homeDirectory = "/home/your-username"; # or /Users/your-username on macOS
  
  home.packages = with pkgs; [
    # Add your tools here
  ];
}
```

---

## Part 2: Set Up the New Host to Use This Config

### For NixOS (first-time install)

#### Step 1: Install NixOS

1. Boot into NixOS installer
2. Follow installer prompts (partition disks, create user, etc.)
3. During installation, when prompted for configuration, you can use defaults

#### Step 2: Generate hardware configuration

After first boot, generate your hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Copy this to your repo:
```bash
# On your development machine:
scp root@my-nixos-host:/tmp/hardware-configuration.nix hosts/my-nixos-host/
```

Or manually copy the output into `hosts/my-nixos-host/hardware-configuration.nix`.

#### Step 3: Clone the repo and set up SSH

On the new NixOS host:

```bash
# Generate SSH key for git
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "my-nixos-host"

# Clone the config repo
git clone <your-repo-url> /etc/nixos
cd /etc/nixos/hosts/my-nixos-host

# (Optional) Add host SSH key to GitHub/GitLab for deployment
cat ~/.ssh/id_ed25519.pub
# Add this to your git service's deploy keys
```

#### Step 4: First flake rebuild

```bash
cd /etc/nixos/hosts/my-nixos-host
sudo nixos-rebuild switch --flake .
```

If successful, your system now uses the flake configuration.

---

### For macOS (with nix-darwin)

#### Step 1: Install Nix

```bash
# Install Nix with flakes support
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```

#### Step 2: Clone the repo and set up SSH

```bash
# Generate SSH key for git
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "my-darwin-host"

# Clone the config repo
git clone <your-repo-url> ~/nixos-config
cd ~/nixos-config/hosts/my-darwin-host

# Add host SSH key to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub
```

#### Step 3: First nix-darwin build and switch

```bash
cd ~/nixos-config/hosts/my-darwin-host

# Generate the flake inputs
nix flake update

# Build nix-darwin
nix run nix-darwin -- switch --flake .

# Link the configuration to system location (optional but useful)
# nix run nix-darwin -- switch --flake . --show-trace
```

After switching, future rebuilds:
```bash
darwin-rebuild switch --flake .
```

---

### For WSL2 / Lix (lightweight Nix alternative)

If using Lix instead of traditional Nix:

```bash
# Install Lix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh

# Follow the same steps as NixOS or darwin above
```

---

## Part 3: Post-Setup Steps

### Add SSH keys for secrets management

If you plan to use agenix for secrets (see [secrets.md](secrets.md)):

```bash
# On your new host
cat ~/.ssh/id_ed25519.pub

# Add this to shared/secrets/secrets.nix in your repo
# Re-encrypt existing secrets to include the new host's key
```

### Enable and configure services

Edit your host's `configuration.nix` to enable services:

```nix
{
  imports = [
    ../../modules/services/jellyfin
    ../../modules/services/homepage
    # ... other services
  ];

  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .  # NixOS
darwin-rebuild switch --flake .      # macOS
```

### Set up home-manager (NixOS only - standalone)

If using home-manager standalone:

```bash
home-manager switch --flake .#username@hostname
```

---

## Troubleshooting

**Flake won't evaluate:**
```bash
nix flake check
```

**Missing nixpkgs:**
```bash
nix flake update
```

**SSH key not found during rebuild:**
```bash
ssh-add ~/.ssh/id_ed25519
```

**Home-manager conflicts with existing files:**
```bash
home-manager switch --flake . -b backup
```

See [docs/secrets.md](secrets.md) for secrets-specific setup.
See [docs/modules.md](modules.md) for using and creating modules.
