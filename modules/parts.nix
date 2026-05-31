{ inputs, ... }: {
  imports = [
    inputs.disko.flakeModules.disko
    inputs.home-manager.flakeModules.home-manager
  ];

  systems = [ "x86_64-linux" "aarch64-darwin" ];
}