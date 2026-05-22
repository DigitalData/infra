{
  description = "A simple NixOS flake";

  inputs = {
    # Official NixOS package source, nixos-25.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: {
    nixosConfigurations.octantis = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        # Import old configuration
	      ./configuration.nix
        ./disk.nix
      ];
    };
  };
}
