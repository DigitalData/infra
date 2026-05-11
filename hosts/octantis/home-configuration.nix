{ config, pkgs, ... }:

{
  # Home-manager configuration for xavtrav user on octantis
  # This runs standalone with: home-manager switch --flake .#xavtrav@octantis

  imports = [
    ../../modules/users/digitaldata.nix
  ];

  # Pass host-specific args to imported modules
  _module.args.hostname = "octantis";
  _module.args.isLinux = true;

  home.username = "digitaldata";
  home.homeDirectory = "/home/digitaldata";

  # Home-manager state version
  home.stateVersion = "25.11";
}
