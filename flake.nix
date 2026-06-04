{
  description = "Shared configurations for DigitalData hosts";

  inputs = {
    # Official NixOS package source, nixos-25.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Iterative-deepening module imports
    import-tree.url = "github:denful/import-tree";

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

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } 
  {
    imports = [
      inputs.disko.flakeModules.disko
      inputs.home-manager.flakeModules.home-manager
      inputs.import-tree [./modules ./hosts]
    ];

    systems = [ "x86_64-linux" "aarch64-darwin" ];
  };
}
