{ self, inputs, ... }:
{
  flake.userModules.digitaldata = { pkgs, ... }: {
    users.users.digitaldata = {
      isNormalUser = true;
      description = "DigitalData";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILk4bC/9jWdrMGhuJTfIVpc+YyEULpFKaGQHIL2sRtV8 digitaldata@octantis"
      ];
      packages = with pkgs; [
        neovim
      ];
    };
  };

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