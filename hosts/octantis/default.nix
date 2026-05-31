{ self, inputs, ... }:
{

  flake.nixosConfigurations.octantis = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules._base
      self.nixosHardwareModules.octantis
      self.nixosModules.octantis
      self.nixosDiskModules.octantis
    ];
  };

}