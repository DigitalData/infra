{ self, inputs, ... }:
{

  flake = {

    nixosModules.octantis = { pkgs, config, ... }: {
      # TODO: this
    };

    nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.disko.nixosModules.disko
        ../../old_hosts/octantis/configuration.nix
        ../../old_hosts/octantis/disk.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.digitaldata = import ../../old_hosts/octantis/home.nix;
          };
        }
      ];
    };
  };
}