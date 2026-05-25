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
    initExtra = ''clear && neofetch'';
    shellAliases = {
      "os-config" = '_BACK_DIR="$(dirname "$(realpath "$0")")" && cd /etc/nixos';
      "os-back" = 'cd "$_BACK_DIR"';
      "os-rebuild" = 'sudo nixos-rebuild switch --flake /etc/nixos/hosts/octantis';
      "os-git-auth" = 'sh /etc/nixos/scripts/config/git-authenticate.sh';
      "os-pull" = 'sh /etc/nixos/scripts/config/os-pull.sh';
    };
  };
  
  home.stateVersion = "25.11";
}
