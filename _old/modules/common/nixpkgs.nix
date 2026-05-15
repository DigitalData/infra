{ config, pkgs, ... }:

{
  # Common nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  # Add overlays here if needed
  # nixpkgs.overlays = [ ... ];
}
