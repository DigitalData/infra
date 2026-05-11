{ config, pkgs, hostname, isLinux ? false, ... }:

{
  # User-level home-manager configuration for digitaldata user
  # Provides a reusable user environment across different hosts

  imports = [
    ../shells/bash.nix
  ];

  # Configure git
  programs.git = {
    enable = true;
    userName = "digitaldata";
    userEmail = "legoxavierlocketravers@gmail.com";
  };

  # Add common user packages
  home.packages = with pkgs; [
    git
    neovim
  ];

  # Services that should run in user session
  services.ssh-agent.enable = true;
}
