{ ... }:
{
 
  flake.modules.nixos.media = { lib, config, pkgs, ... }: lib.mkIf config.media.jelly {
    
    # Create required dirs
    systemd.tmpfiles.rules = lib.flatten [
      "d ${config.media.dir.media} 0775 root ${config.media.users.group} -"
      (builtins.map (pf: "d ${config.media.dir.media}/${pf} 0775 root ${config.media.users.group} -") [ "movies" "tv" "music" ])
    ];
  
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
      configDir = "${config.media.dir.data}/jellyseerr";
    };

  };

}