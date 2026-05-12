{
  description = "Darwin macOS configuration with nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, agenix }:
    let
      system = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs
    in
    {
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit agenix; };
        modules = [
          agenix.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
