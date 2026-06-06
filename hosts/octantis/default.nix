{ self, inputs, ... }:
{

  flake.nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.octantis

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
      
      self.modules.nixos.base
      self.modules.nixos.arr
      self.nixosModules.octantis
      self.userModules.digitaldata
    ];
  };

  flake.nixosModules.octantis = { pkgs, config, lib, ... }: {
    networking.hostName = "octantis"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    preferences.media.dir = /data/media;

    # NVIDIA Support
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      nvidia-container-toolkit.enable = true;
      nvidia = {
        branch = "legacy_580";
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
      };
    };
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    home-manager = {
      users.digitaldata = self.homeModules.digitaldata;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   neovim
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    # ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}