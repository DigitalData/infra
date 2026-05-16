{
  description = "A simple NixOS flake";

  inputs = {
    # Official NixOS package source, nixos-25.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.octantis = nixpkgs.lib.nixosSystem {
      modules = [
        # Import old configuration
	./configuration.nix
      ];
    };
  };
}
