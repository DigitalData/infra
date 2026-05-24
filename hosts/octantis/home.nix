{config, pkgs, ...}:

{
  home.username = "digitaldata";
  home.homeDirectory = "/home/digitaldata";

  home.packages = with pkgs; [
    neofetch # Terminal HUD
  ];

  programs.git = {
    enable = true;
    userName = "DigitalData";
    userEmail = "legoxavierlocketravers@gmail.com";
    settings = {
      safe.directory = "/etc/nixos";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "rebuild-os" = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/octantis";
    };
  };
  
  home.stateVersion = "25.11";
}