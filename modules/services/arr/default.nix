{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.media = {
      dir = lib.mkOption {
        type = lib.types.path;
        description = "Path to the media directory.";
      };
      torrentDir = lib.mkOption {
        type = lib.types.path;
        description = "Path to the torrent directory.";
      };
    };
  };

  flake.modules.nixos.arr = { config, pkgs, ... }: {

    # Create required dirs
    systemd.tmpfiles.rules = [
      "d ${config.media.dir} 0755 root root -"
      "d ${config.media.torrentDir} 0755 root root -"
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig.BitTorrent.DefaultSavePath = config.media.torrentDir;
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
