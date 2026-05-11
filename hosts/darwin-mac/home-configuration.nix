{ config, pkgs, ... }:

{
  # Home-manager configuration for macOS
  # Integrated via nix-darwin

  imports = [
    ../../modules/users/digitaldata.nix
  ];

  # Pass host-specific args to imported modules
  _module.args.hostname = "darwin-mac";
  _module.args.isLinux = false;

  home.username = "digitaldata";
  home.homeDirectory = "/Users/digitaldata";

  home.stateVersion = "25.11";
}
