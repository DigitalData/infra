{ config, pkgs, ... }:

{
  # Home-manager configuration for xavtrav user on octantis
  # This runs standalone with: home-manager switch --flake .#xavtrav@octantis

  home.username = "xavtrav";
  home.homeDirectory = "/home/xavtrav";

  # Home-manager state version
  home.stateVersion = "25.11";

  # Basic home-manager configuration
  programs.bash.enable = true;

  # Add packages available to the user
  home.packages = with pkgs; [
    # Development tools
    git
    neovim
    # Add more tools here as needed
  ];

  # Configure git
  programs.git = {
    enable = true;
    userName = "xavtrav";
    # userEmail = "your-email@example.com";  # TODO: Set your email
  };

  # Services that should run in user session
  services.ssh-agent.enable = true;
}
