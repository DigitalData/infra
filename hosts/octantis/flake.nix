{
  description = "Octantis home server NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.octantis = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit agenix; };
        modules = [
          agenix.nixosModules.default
          ./configuration.nix
        ];
      };

      # Standalone home-manager configuration
      homeConfigurations."xavtrav@octantis" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          agenix.homeManagerModules.default
          ./home-configuration.nix
        ];
      };
    };
}
