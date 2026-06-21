{ ... }:
{
 
  flake.modules.nixos.media = { lib, config, pkgs, ... }: lib.mkIf config.media.jelly {
    
    caddy.exposePorts = {
      jellyfin = 8096;
      jellyseerr = config.services.jellyseerr.port;
    };

    # Media server
    services.jellyfin = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/jellyfin";
    } // config.media.users;

    # Media Request Manager
    services.jellyseerr = {
      enable = true;
      openFirewall = false;
      # TODO: Enable/move once nixpkgs 26 is updated
      # configDir = "${config.media.dir.data}/jellyseerr";
    };
    users.groups.${config.media.users.group}.members = [ "jellyseerr" ];

  };

}