{
  description = "Octantis home server NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix }:
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
    };
}
