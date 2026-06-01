{ self, inputs, ... }:
{

  flake.nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosHardwareModules.octantis
      inputs.disko.nixosModules.disko
      self.nixosDiskModules.octantis
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules._base
      self.nixosModules.octantis
      self.userModules.digitaldata
    ];
  };

}