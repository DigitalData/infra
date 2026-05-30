{ inputs, ... }: {

  flake = {

    nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.disko.nixosModules.disko
        # Import old configuration
        ./configuration.nix
        ./disk.nix
        
        inputs.home-manager.nixosModules.home-manager
        {
          inputs.home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.digitaldata = import ./home.nix;
          };
        }
      ];
    };

  };

}