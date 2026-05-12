{
  description = "Darwin macOS configuration with nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin }:
    let
      system = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs
    in
    {
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
}
