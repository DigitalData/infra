{ config, pkgs, ... }:

{
  # Nextcloud file sync & collaboration configuration
  # TODO: Configure nextcloud service, database, domain, trusted domains
  services.nextcloud.enable = false;
}
