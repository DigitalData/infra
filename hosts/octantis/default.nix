{ self, inputs, ... }:
{

  flake.nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules._base
      self.nixosHardwareModules.octantis
      self.nixosModules.octantis
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

}