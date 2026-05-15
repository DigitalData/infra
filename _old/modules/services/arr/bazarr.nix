{ config, pkgs, ... }:

{
  # Bazarr subtitle management
  # TODO: Configure bazarr service, port, sonarr/radarr integration
  services.bazarr.enable = false;
}
