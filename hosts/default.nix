{

  flake.nixosModules._base = { config, lib, modulesPath, ... }:
  {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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
        settings = {
          X11Forwarding = true;
          PasswordAuthentication = false;
        };
        openFirewall = true;
      };
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
    
    environment.variables = {
      HOSTNAME = config.networking.hostName;
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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = lib.mkDefault false;

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