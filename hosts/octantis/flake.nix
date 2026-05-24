{
  description = "A simple NixOS flake";

  inputs = {
    # Official NixOS package source, nixos-25.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }@inputs: {
    nixosConfigurations.octantis = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        # Import old configuration
	      ./configuration.nix
        ./disk.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.digitaldata = import ./home.nix;
        }
      ];
    };
  };
}
