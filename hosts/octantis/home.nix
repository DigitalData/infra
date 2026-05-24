{config, pkgs, ...}:

{
  home.username = "digitaldata";
  home.homeDirectory = "/home/digitaldata";

  home.packages = with pkgs; [
    neofetch # Terminal HUD
  ];

  programs.git = {
    enable = true;
    config = {
      safe.directory = "/etc/nixos";
      user.name = "DigitalData";
      user.email = "legoxavierlocketravers@gmail.com";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "rebuild-os" = "sudo nixos-rebuild switch --flake /etc/nixos/hosts/${config.networking.hostName}#${config.networking.hostName}";
    };
  };
  
  home.stateVersion = "25.11";
}