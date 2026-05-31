{ self, inputs, ... }:
{

  flake.homeModules.digitaldata = { pkgs, ... }: {
    home = {
      username = "digitaldata";
      homeDirectory = "/home/digitaldata";
      packages = with pkgs; [
        neofetch # Terminal HUD
      ];
      stateVersion = "25.11";
    };

    programs = {
      git = {
        enable = true;
        settings = {
          user.name = "DigitalData";
          user.email = "legoxavierlocketravers@gmail.com";
          safe.directory = "/etc/nixos";
        };
      };
      bash = {
        enable = true;
        initExtra = ''clear && neofetch'';
        shellAliases = {
          "os-config" = ''_BACK_DIR="$(realpath .)" && cd /etc/nixos'';
          "os-back" = ''cd "$_BACK_DIR"'';
          "os-rebuild" = ''sudo nixos-rebuild switch --flake /etc/nixos'';
          "os-git-auth" = ''sh /etc/nixos/scripts/config/git-authenticate.sh'';
          "os-pull" = ''sh /etc/nixos/scripts/config/os-pull.sh'';
        };
      };
    };
    
  };

}