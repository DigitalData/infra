{ config, pkgs, ... }:

{
  # Immich photo/video backup configuration
  # TODO: Configure immich service, database, upload paths
  services.immich.enable = false;
}
