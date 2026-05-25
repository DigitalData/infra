{config, pkgs, ...}:

{
  home.username = "digitaldata";
  home.homeDirectory = "/home/digitaldata";

  home.packages = with pkgs; [
    neofetch # Terminal HUD
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "DigitalData";
      user.email = "legoxavierlocketravers@gmail.com";
      safe.directory = "/etc/nixos";
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''neofetch'';
    shellAliases = {
      "rebuild-os" = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/octantis";
    };
  };
  
  home.stateVersion = "25.11";
}
