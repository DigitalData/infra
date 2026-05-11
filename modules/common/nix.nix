{ config, pkgs, ... }:

{
  # Common nix daemon and flake settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Add auto-optimise-store for faster garbage collection
  nix.settings.auto-optimise-store = true;
}
