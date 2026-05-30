# How to create a new host?

## Linux Hosts

| Step | Description | Where |
| --- | --- | --- |
| 0 | Create installer USB with NixOS ISO. | Local Machine |
| 1 | Create a new `hosts/<hostname>` directory and `disk.nix` file. | Push to Repository |
| 2 | Load into installer environment. | New Host / Installer Environment |
| [3](#adding-flakes-support-to-a-configuration) | Rebuild environment with flakes support. | New Host / Installer Environment |
| [4](#cloning-this-repository-and-installing-the-new-host) | Clone this repository and run the installer script. | New Host / Installer Environment |
| [5] | First boot into new host | New Host |

## WSL Hosts

TBD

## MacOS Hosts

TBD

## Appendix A: Detailed Steps

### Adding flakes support to a configuration.
1. Enable flakes in `configuration.nix` if not already enabled.
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
2. Rebuild the configuration with flakes support.
```bash
sudo nixos-rebuild switch #[path-to-configuration]
```

### Cloning this repository and installing the new host.

```bash
git clone https://github.com/DigitalData/infra.git /etc/nixos
cd /etc/nixos

# Run installer script
sh ./scripts/install/fresh-install.sh ./hosts/<hostname>
```

### First boot into new host

```bash
cd /etc/nixos
sh ./scripts/install/first-boot.sh
```