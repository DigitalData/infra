{
  description = "Shared configurations for DigitalData hosts";

  inputs = {
    # Official NixOS package source, nixos-25.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Config modularization
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Disk partitioning and mounting configuration
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User-level configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }: 
    flake-parts.lib.mkFlake { inherit inputs; }
    {
      imports = [
        ./hosts/octantis
      ];
    };
}
