{ config, pkgs, ... }:

{
  # nix-darwin system configuration for macOS
  # TODO: Customize for your Mac setup

  system.stateVersion = 5; # Used for backwards compatibility, read docs before changing.

  # Enable home-manager
  users.users."xavtrav".home = "/Users/xavtrav";

  # System packages
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  # System settings
  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.finder.AppleShowAllExtensions = true;

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # macOS specific settings
  services.nix-daemon.enable = true;
}
