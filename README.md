# nixos-config

A dendritic NixOS and nix-darwin configuration monorepo for managing multiple hosts.

## Directory Structure

```
nixos-config/
├── flake.nix                         # Root flake metadata (optional)
├── README.md                         # This file
├── modules/                          # Shared configuration modules (trunk)
│   ├── services/                     # Service modules
│   │   ├── jellyfin/                 # Media server
│   │   ├── homepage/                 # Dashboard
│   │   ├── immich/                   # Photo backup
│   │   ├── nextcloud/                # File sync & collaboration
│   │   └── arr/                      # Arr services (sonarr, radarr, prowlarr, etc.)
│   ├── desktop/                      # Desktop environment modules
│   │   ├── ghostty.nix               # Terminal emulator
│   │   ├── amethyst.nix              # Tiling window manager (macOS)
│   │   └── vscode.nix                # VS Code editor
│   └── common/                       # Common system configurations
│       ├── nixpkgs.nix               # Nixpkgs settings & overlays
│       ├── nix.nix                   # Nix daemon settings, flakes, etc.
│       └── users.nix                 # Reusable user definitions
├── hosts/                            # Per-host configurations (branches)
│   ├── octantis/                     # Home server (NixOS)
│   │   ├── flake.nix                 # Host-specific flake
│   │   ├── configuration.nix         # System configuration
│   │   ├── hardware-configuration.nix # Generated hardware config (auto)
│   │   ├── home-configuration.nix    # Home-manager user config
│   │   ├── secrets.yaml              # Encrypted secrets (agenix)
│   │   └── secrets/                  # Unencrypted secrets (git-ignored)
│   └── darwin-mac/                   # Mac workstation (nix-darwin)
│       ├── flake.nix                 # Host-specific flake
│       ├── configuration.nix         # Darwin system configuration
│       ├── home-configuration.nix    # Home-manager user config
│       ├── secrets.yaml              # Encrypted secrets template
│       └── secrets/                  # Unencrypted secrets (git-ignored)
└── .gitignore                        # Git ignore rules
```

## Quick Start: Adding a New Host

### 1. Copy the host template

Choose `octantis` (NixOS) or `darwin-mac` (macOS) as your template:

```bash
cp -r hosts/octantis hosts/my-new-host
# or for macOS:
# cp -r hosts/darwin-mac hosts/my-new-host
```

### 2. Customize the configuration

Edit `hosts/my-new-host/configuration.nix`:
- Change `networking.hostName` (if NixOS)
- Update hardware-specific settings (CPU, filesystems, boot)
- Adjust timezone, locale, users

Edit `hosts/my-new-host/home-configuration.nix`:
- Update `home.username` and `home.homeDirectory`
- Add user-specific packages and dotfiles

Edit `hosts/my-new-host/flake.nix`:
- Update the `darwinConfigurations` or `nixosConfigurations` name to match your host
- Update system architecture if needed (`x86_64-linux` vs `aarch64-darwin`, etc.)

### 3. Set up hardware (NixOS only)

Generate hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/my-new-host/hardware-configuration.nix
```

### 4. Generate SSH key for secrets encryption (optional)

If you plan to use agenix for secrets:

```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Add your public key to shared secrets configuration (TODO: add this)
```

### 5. Build and switch

For NixOS:

```bash
cd hosts/my-new-host
sudo nixos-rebuild switch --flake .#<hostname>
```

For macOS (nix-darwin):

```bash
cd hosts/darwin-mac
nix run nix-darwin -- switch --flake .
```

For home-manager (standalone):

```bash
cd hosts/my-new-host
home-manager switch --flake .#<username>@<hostname>
```

## Secrets Management with agenix

### Overview

Secrets are encrypted with your SSH public key and stored in `secrets.yaml`. They're decrypted on rebuild using agenix.

### Setup

1. **Generate SSH key** (if needed):
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
   ```

2. **Initialize agenix** in your host directory:
   ```bash
   cd hosts/octantis
   agenix -e secrets.yaml
   ```

3. **Add a secret**:
   ```bash
   # Create a secret file
   echo "my-password" > secrets/db_password

   # Encrypt it
   agenix -e secrets/db_password.age

   # Add to secrets.yaml:
   # db_password:
   #   file = ./secrets/db_password.age
   #   owner = "jellyfin"
   #   group = "jellyfin"
   #   mode = "0440"
   ```

4. **Use the secret in configuration**:
   ```nix
   services.jellyfin.enable = true;
   services.jellyfin.dataDir = config.age.secrets.db_password.path;
   ```

### Encryption Keys

To add another user's SSH key for encryption:

1. Get their public key: `cat ~/.ssh/id_ed25519.pub`
2. Add to `shared/secrets/secrets.nix` (TODO: create this file)
3. Re-encrypt secrets with the new key

## Using Service Modules

Service modules are located in `modules/services/`. To enable a service in your host:

### Example: Enable Jellyfin

In your host's `configuration.nix`:

```nix
{
  imports = [
    ../../modules/services/jellyfin
    # ... other imports
  ];

  # Enable and configure jellyfin
  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

### Example: Enable multiple arr services

```nix
{
  imports = [
    ../../modules/services/arr/sonarr.nix
    ../../modules/services/arr/radarr.nix
    ../../modules/services/arr/prowlarr.nix
    # ... other imports
  ];

  # Enable the services
  services.sonarr.enable = true;
  services.radarr.enable = true;
  services.prowlarr.enable = true;
}
```

## Available Modules

### Services (`modules/services/`)
- **jellyfin**: Media server
- **homepage**: Dashboard
- **immich**: Photo and video backup
- **nextcloud**: File sync and collaboration
- **arr**: Automation suite
  - sonarr: TV series automation
  - radarr: Movie automation
  - prowlarr: Indexer aggregator
  - bazarr: Subtitle management
  - jellyseer: Media request interface
  - lidarr: Music automation

### Desktop (`modules/desktop/`)
- **ghostty**: Terminal emulator
- **amethyst**: Tiling window manager (macOS)
- **vscode**: Code editor

### Common (`modules/common/`)
- **nixpkgs.nix**: Nixpkgs settings and overlays
- **nix.nix**: Nix daemon settings and experimental features
- **users.nix**: Reusable user definitions

## Building and Updating

### Build without switching

```bash
cd hosts/my-host
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
```

### Update flake inputs

```bash
nix flake update
```

### Check flake evaluation

```bash
nix flake show
```

## Troubleshooting

### Flake shows evaluation errors
```bash
cd hosts/my-host
nix flake check
```

### Home-manager complains about existing files
```bash
home-manager switch --flake .#<user>@<host> -b backup
```

### Agenix can't decrypt secrets
- Ensure your SSH key is loaded: `ssh-add`
- Check that the secret was encrypted with your key

### NixOS rebuild fails with missing hardware config
```bash
sudo nixos-generate-config --show-hardware-config > hosts/my-host/hardware-configuration.nix
```

## Next Steps

- [ ] Create `shared/secrets/secrets.nix` with SSH keys for agenix
- [ ] Fill in service modules (jellyfin, immich, nextcloud, arr stack)
- [ ] Add desktop module configurations (ghostty, vscode, amethyst)
- [ ] Test octantis rebuild: `cd hosts/octantis && sudo nixos-rebuild switch --flake .`
- [ ] Set up darwin-mac when ready for Mac deployment
- [ ] Add CI/CD pipeline (GitHub Actions) to validate all hosts on push

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [home-manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/lnl7/nix-darwin)
- [agenix](https://github.com/ryantm/agenix)
- [Flakes](https://nixos.wiki/wiki/Flakes)