{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.media = {
      dir = lib.mkOption {
        type = lib.types.str;
        description = "Path to the media directory.";
      };
      torrentDir = lib.mkOption {
        type = lib.types.str;
        description = "Path to the torrent directory.";
      };
    };
  };

  flake.modules.nixos.arr = { lib, config, pkgs, ... }: {

    # Create a media group and add all relevant users to it
    users.groups.media.members = [
      "jellyfin"
      "qbittorrent"
      "prowlarr"
      "radarr"
      "sonarr"
      "bazarr"
      "lidarr"
    ];

    # Create required dirs
    systemd.tmpfiles.rules = lib.flatten [
      "d ${config.media.dir} 0775 root media -"
      (builtins.map (pf: "d ${config.media.dir}/${pf} 0775 root media -") [ "movies" "tv" "music" ])
      "d ${config.media.torrentDir} 0775 root media -"
    ];

    networking.wg-quick.interfaces.vpn-unlimited.configFile = "/etc/wireguard/vpn-unlimited.conf";

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      extraArgs = [
        "--confirm-legal-notice"
      ];
      serverConfig = {
        BitTorrent.Session.DefaultSavePath = config.media.torrentDir;
      };
    };

    # Request manager
    services.jellyseerr = {
      enable = true;
      openFirewall = true;
    };

    # Indexer manager
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

    # Bypass cloudflare protection for indexers
    services.flaresolverr = {
      enable = true;
      openFirewall = true;
    };

    # Movies
    services.radarr = {
      enable = true;
      openFirewall = true;
    };

    # TV Shows
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };

    # Subtitles
    services.bazarr = {
      enable = true;
      openFirewall = true;
    };

    # Music
    services.lidarr = {
      enable = true;
      openFirewall = true;
    };
  };

}
