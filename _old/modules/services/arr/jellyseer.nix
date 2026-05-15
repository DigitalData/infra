{ config, pkgs, ... }:

{
  # Jellyseer media request interface for Jellyfin
  # TODO: Configure jellyseer service, port, jellyfin integration
  services.jellyseerx.enable = false;
}
