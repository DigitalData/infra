# nixos-config

A dendritic NixOS and nix-darwin configuration monorepo for managing multiple hosts.

## 📖 Documentation

Start here for detailed guidance:

- **[Quickstart](docs/quickstart.md)** — Get a new host up and running (NixOS, macOS, WSL2)
- **[Secrets Management](docs/secrets.md)** — Encrypt and manage secrets with agenix (across Windows/WSL2/Linux/macOS)
- **[Modules](docs/modules.md)** — Understand and use the shared module system
- **[TODO](docs/TODO.md)** — Outstanding tasks and future goals

## Directory Structure

```
nixos-config/
├── docs/                             # Documentation
│   ├── quickstart.md                 # Quick start guide
│   ├── secrets.md                    # Secrets management with agenix
│   ├── modules.md                    # Module system overview
│   └── TODO.md                       # Task tracking
├── modules/                          # Shared configuration modules (trunk)
│   ├── services/                     # Service modules (jellyfin, immich, arr, etc.)
│   ├── desktop/                      # Desktop tools (ghostty, vscode, amethyst)
│   └── common/                       # System-wide settings (nixpkgs, nix, users)
├── hosts/                            # Per-host configurations (branches)
│   ├── octantis/                     # Home server (NixOS)
│   │   ├── flake.nix                 # Host-specific flake
│   │   ├── configuration.nix         # System configuration
│   │   ├── hardware-configuration.nix
│   │   ├── home-configuration.nix
│   │   └── secrets.yaml
│   └── darwin-mac/                   # Mac workstation (nix-darwin)
│       ├── flake.nix
│       ├── configuration.nix
│       ├── home-configuration.nix
│       └── secrets.yaml
├── shared/                           # Shared configuration (future)
│   └── secrets/                      # Master secrets configuration (agenix keys)
├── flake.nix                         # Root flake metadata (optional)
└── .gitignore                        # Git ignore rules
```

## Quick Overview

### For Complete Beginners

1. Read [Quickstart](docs/quickstart.md) Part 1 to understand the config structure
2. Copy and customize a host template
3. Follow Part 2 to deploy on your target machine

### For Adding Secrets

See [Secrets Management](docs/secrets.md):
- Managing secrets from **Windows/WSL2**, **Linux/NixOS**, or **macOS**
- How encrypted secrets travel through git and get decrypted on rebuild
- Multi-host secret encryption

### For Understanding Modules

See [Modules](docs/modules.md):
- Service module overview (jellyfin, immich, nextcloud, arr stack)
- Desktop module overview (ghostty, vscode, amethyst)
- How to enable and configure modules

## Key Concepts

**Dendritic Pattern:**
- `modules/` = shared trunk (reusable configs)
- `hosts/` = per-host branches (one flake per host)
- Each host's flake imports from the trunk

**Secrets with agenix:**
- Encrypted at rest in git (`secrets/*.age`)
- Decrypted on rebuild using host's SSH private key
- Can manage from Windows (WSL2), Linux, or macOS

**Per-host Flakes:**
- Each host has its own `flake.nix` (independent, testable)
- Rebuild: `cd hosts/my-host && sudo nixos-rebuild switch --flake .`

## Common Tasks

**Add a new NixOS host:**
```bash
cp -r hosts/octantis hosts/my-host
# Edit hosts/my-host/flake.nix, configuration.nix
sudo nixos-rebuild switch --flake ./hosts/my-host
```

**Add a new macOS host:**
```bash
cp -r hosts/darwin-mac hosts/my-mac
# Edit hosts/my-mac/flake.nix, configuration.nix
nix run nix-darwin -- switch --flake ./hosts/my-mac
```

**Enable Jellyfin service on a host:**
```nix
# In hosts/octantis/configuration.nix
{
  imports = [ ../../modules/services/jellyfin ];
  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

**Add an encrypted secret:**
```bash
cd hosts/octantis
nix run github:ryantm/agenix -- -e secrets/password.age
# Edit in plaintext, save to encrypt automatically
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [home-manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/lnl7/nix-darwin)
- [agenix](https://github.com/ryantm/agenix)
- [Flakes](https://nixos.wiki/wiki/Flakes)