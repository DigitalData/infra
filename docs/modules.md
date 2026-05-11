# Modules Overview

Understanding and using the shared module structure in nixos-config.

## Module Structure

Modules are reusable Nix configurations organized by category:

```
modules/
├── services/           # Background services (jellyfin, immich, etc.)
├── desktop/            # Desktop tools & environments (ghostty, vscode, etc.)
└── common/             # System-wide settings (nixpkgs, nix daemon, users)
```

---

## Services Modules

Service modules enable and configure server applications.

### Available Services

**Media & Entertainment:**
- `modules/services/jellyfin/` — Jellyfin media server
- `modules/services/homepage/` — Homepage dashboard
- `modules/services/immich/` — Photo/video backup service
- `modules/services/nextcloud/` — File sync and collaboration

**Arr Stack (Automation):**
- `modules/services/arr/sonarr.nix` — TV series automation
- `modules/services/arr/radarr.nix` — Movie automation
- `modules/services/arr/prowlarr.nix` — Indexer aggregator
- `modules/services/arr/bazarr.nix` — Subtitle management
- `modules/services/arr/jellyseer.nix` — Media request interface
- `modules/services/arr/lidarr.nix` — Music automation

### Using a Service Module

#### Option 1: Import the entire service

For services with a `default.nix`:

```nix
# In hosts/octantis/configuration.nix
{
  imports = [
    ../../modules/services/jellyfin   # Imports default.nix
    ../../modules/services/immich
  ];

  # Then configure
  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

#### Option 2: Import individual service files

For services in a folder (like arr):

```nix
# In hosts/octantis/configuration.nix
{
  imports = [
    ../../modules/services/arr/sonarr.nix
    ../../modules/services/arr/radarr.nix
    ../../modules/services/arr/prowlarr.nix
  ];

  services.sonarr.enable = true;
  services.radarr.enable = true;
  services.prowlarr.enable = true;

  # Configure with NixOS options
  services.sonarr.port = 8989;
  services.radarr.port = 7878;
}
```

### Basic Service Module Template

Here's what a service module looks like:

```nix
# modules/services/jellyfin/default.nix
{ config, pkgs, ... }:

{
  # Stub/placeholder for future configuration
  # TODO: Add actual service configuration here

  services.jellyfin.enable = false;  # Disabled by default
  
  # Example options that could be configured:
  # services.jellyfin.dataDir = "/var/lib/jellyfin";
  # services.jellyfin.port = 8096;
}
```

When you fill this in, add:
- Service enablement options
- Package dependencies
- Network configuration (ports, reverse proxy)
- Storage paths and permissions
- Environment variables and secrets

---

## Desktop Modules

Desktop modules configure user-facing tools and environments (primarily for home-manager).

### Available Desktop Modules

- `modules/desktop/ghostty.nix` — Terminal emulator configuration
- `modules/desktop/amethyst.nix` — macOS tiling window manager
- `modules/desktop/vscode.nix` — VS Code editor and extensions

### Using Desktop Modules

Desktop modules are typically used in home-manager configs:

```nix
# In hosts/darwin-mac/home-configuration.nix
{
  imports = [
    ../../modules/desktop/ghostty.nix
    ../../modules/desktop/vscode.nix
    ../../modules/desktop/amethyst.nix
  ];

  # Enable and configure
  programs.ghostty.enable = true;
  programs.vscode.enable = true;
}
```

### Desktop Module Template

```nix
# modules/desktop/ghostty.nix
{ config, pkgs, ... }:

{
  # Terminal emulator configuration
  programs.ghostty = {
    enable = false;  # Disabled by default
    
    # TODO: Configure fonts, themes, keybindings, etc.
    # settings = {
    #   font-size = 12;
    #   theme = "Dracula";
    # };
  };
}
```

---

## Common Modules

Common modules provide system-wide settings shared across hosts.

### nixpkgs.nix

Configures Nix package manager defaults:

```nix
# modules/common/nixpkgs.nix
{
  nixpkgs.config.allowUnfree = true;  # Allow unfree packages
  
  # Add overlays here for package customizations
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     myPackage = prev.myPackage.override { ... };
  #   })
  # ];
}
```

**When to use:**
- Allow unfree packages (Discord, Nvidia drivers, etc.)
- Apply package overlays or patches
- Set nixpkgs-specific options

### nix.nix

Configures the Nix daemon and experimental features:

```nix
# modules/common/nix.nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
}
```

**When to use:**
- Enable flakes and nix-command
- Configure garbage collection
- Set Nix daemon options
- Cache configuration

### users.nix

Placeholder for reusable user definitions:

```nix
# modules/common/users.nix
{
  # Define common user settings here
  # Can be imported per-host if needed
}
```

**When to use:**
- Define user accounts used across multiple hosts
- Configure SSH keys, groups, shell
- Set default user environment

---

## Creating a New Module

### Step 1: Create the directory structure

```bash
mkdir -p modules/services/my-service
touch modules/services/my-service/default.nix
```

Or for single-file modules:

```bash
touch modules/services/my-service.nix
```

### Step 2: Write the module

```nix
# modules/services/my-service/default.nix
{ config, pkgs, lib, ... }:

{
  options.services.myService = {
    enable = lib.mkEnableOption "my-service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for my-service";
    };
  };

  config = lib.mkIf config.services.myService.enable {
    systemd.services.my-service = {
      description = "My Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig = {
        ExecStart = "${pkgs.my-package}/bin/my-service --port ${toString config.services.myService.port}";
        Restart = "always";
      };
    };
  };
}
```

### Step 3: Import and use in a host config

```nix
# In hosts/octantis/configuration.nix
{
  imports = [
    ../../modules/services/my-service
  ];

  services.myService.enable = true;
  services.myService.port = 9000;
}
```

---

## Module Best Practices

### ✅ DO

- **Use `lib.mkEnableOption` for booleans** — Allows disabling via `mkForce`
- **Document options** — Add descriptions to all configurable options
- **Use relative paths** — Import from `../../modules/` relative to host config
- **Default to disabled** — Set `enable = false;` for optional services
- **Group related options** — Use `options.services.myService` namespace
- **Use `mkIf`** — Conditionally apply config only when enabled

### ❌ DON'T

- **Hard-code absolute paths** — Use relative imports
- **Put service configs directly in host files** — Extract to modules for reuse
- **Mix home-manager and NixOS configs** — Keep desktop (home-manager) separate from services (NixOS)
- **Create circular imports** — Modules should never import host configs

---

## Module Import Order

Imports are evaluated top-to-bottom. Order matters for:

```nix
{
  imports = [
    # 1. Common settings first (nixpkgs, nix, users)
    ../../modules/common/nixpkgs.nix
    ../../modules/common/nix.nix
    
    # 2. Then services
    ../../modules/services/jellyfin
    ../../modules/services/homepage
    
    # 3. Host-specific overrides last
    ./secrets.yaml  # If using agenix
  ];

  # Host-specific settings override module defaults
  services.jellyfin.dataDir = "/mnt/custom-media";
}
```

---

## Debugging Modules

### Check module evaluation

```bash
nix eval .#nixosConfigurations.octantis.config.services.jellyfin.enable
```

### View merged configuration

```bash
nixos-option services.jellyfin
```

### Build and test without switching

```bash
nix build .#nixosConfigurations.octantis.config.system.build.toplevel
```

---

## Examples

### Enable Jellyfin with custom settings

```nix
{
  imports = [ ../../modules/services/jellyfin ];

  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

### Enable entire arr stack

```nix
{
  imports = [
    ../../modules/services/arr/sonarr.nix
    ../../modules/services/arr/radarr.nix
    ../../modules/services/arr/prowlarr.nix
    ../../modules/services/arr/bazarr.nix
    ../../modules/services/arr/jellyseer.nix
    ../../modules/services/arr/lidarr.nix
  ];

  # Enable all
  services.sonarr.enable = true;
  services.radarr.enable = true;
  services.prowlarr.enable = true;
  services.bazarr.enable = true;
  services.jellyseer.enable = true;
  services.lidarr.enable = true;
}
```

### Override default port for a service

```nix
{
  imports = [ ../../modules/services/arr/sonarr.nix ];

  services.sonarr.enable = true;
  services.sonarr.port = 8989;  # Change from default
}
```

---

## Resources

- [NixOS Module System](https://nixos.org/manual/nixpkgs/stable/#module-system)
- [Writing NixOS Modules](https://nixos.org/manual/nixos/stable/#sec-writing-modules)
- [lib documentation](https://nixos.org/manual/nixpkgs/stable/#lib)
