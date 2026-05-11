{ config, pkgs, ... }:

{
  # Home-manager configuration for macOS
  # Integrated via nix-darwin

  home.stateVersion = "25.11";

  # Home packages
  home.packages = with pkgs; [
    git
    neovim
    # TODO: Add ghostty, vscode, and other tools
  ];

  # Configure git
  programs.git = {
    enable = true;
    userName = "xavtrav";
    # userEmail = "your-email@example.com";
  };

  # Bash configuration
  programs.bash.enable = true;

  # Services
  services.ssh-agent.enable = true;
}
