{ ... }:
{

  flake.modules.nixos.media = { lib, config, pkgs, ... }: lib.mkIf config.media.arr {

    # Create required dirs
    systemd.tmpfiles.rules = lib.flatten [
      "d ${config.media.dir.torrents} 0775 root ${config.media.users.group} -"
      (builtins.map (pf: "d ${config.media.dir.torrents}/${pf} 0775 root ${config.media.users.group} -") [ "movies" "tv" "music" ])
    ];

    caddy.exposePorts = {
      sonarr = config.services.sonarr.settings.server.port;
      radarr = config.services.radarr.settings.server.port;
      prowlarr = config.services.prowlarr.settings.server.port;
      bazarr = config.services.bazarr.listenPort;
      readarr = config.services.readarr.settings.server.port;
      lidarr = config.services.lidarr.settings.server.port;
      qbittorrent = config.services.qbittorrent.webuiPort;
      flaresolverr = config.services.flaresolverr.port;
    };

    # TV Shows
    services.sonarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/sonarr";
    } // config.media.users;

    # Movies
    services.radarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/radarr";
    } // config.media.users;

    # Indexer manager
    services.prowlarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/prowlarr";
    };
    users.groups.${config.media.users.group}.members = [ "prowlarr" ];

    # Subtitles
    services.bazarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/bazarr";
    } // config.media.users;

    # Ebooks
    services.readarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/readarr";
    } // config.media.users;

    # Music
    services.lidarr = {
      enable = true;
      openFirewall = false;
      dataDir = "${config.media.dir.data}/lidarr";
    } // config.media.users;

    # Torrenting
    services.qbittorrent = {
      enable = true;
      openFirewall = false;
      profileDir = "${config.media.dir.data}/qbittorrent";
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          Downloads = {
            SavePath = "${config.media.dir.torrents}";
            TempPath = "${config.media.dir.torrents}/.incomplete";
            TempPathEnabled = true;
          };
          WebUI = {
            # Allow access from reverse proxy
            CSRFProtection = false;
            HostHeaderValidation = false;
          };
        };
      };
    } // config.media.users;

    # Bypass cloudflare protection for indexers
    services.flaresolverr = {
      enable = true;
      openFirewall = false;
    };

  };

}
