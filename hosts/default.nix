{

  flake.modules.nixos.base = { config, lib, ... }:
  {

    environment.variables = {
      # Set the default editor for the system. This is used by programs like `git` and `nixos-rebuild` when they need to open an editor.
      HOME_USERS = builtins.toString config;
    };

    home-manager = {
      useGlobalPkgs = lib.mkDefault true;
      useUserPackages = lib.mkDefault true;
    };

    # Disable unfree packages by default, override in host configuration if necessary
    nixpkgs.config.allowUnfree = lib.mkDefault false;

    # Bootloader.
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # Enable networking
    networking.networkmanager.enable = true;

    # Enable the OpenSSH daemon.
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          X11Forwarding = true;
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
    
    # Set your time zone.
    time.timeZone = "Australia/Melbourne";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };

    # Enables experimental features (mainly Flakes).
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11";
  };

}