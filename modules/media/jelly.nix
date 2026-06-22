{ ... }:
{
 
  flake.modules.nixos.media = { lib, config, pkgs, ... }: lib.mkIf config.media.jelly {
    
    caddy.exposePorts = {
      jellyfin = 8096;
      seerr = config.services.seerr.port;
    };

    # Media server
    services.jellyfin = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/jellyfin";
      cacheDir = "${config.media.dir.data}/cache/jellyfin";
    } // config.media.users;

    # Media Request Manager
    services.seerr = {
      enable = true;
      openFirewall = false;
    };
    users.groups.${config.media.users.group}.members = [ "seerr" ];

  };

}