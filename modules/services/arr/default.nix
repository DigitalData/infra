{ config, ... }:
{

  flake.modules.nixos.base = { pkgs, ... }: {
    options.media = lib.mkOption {
      description = "Configuration for media services.";
      type = lib.types.submodule {
        options.dir = lib.mkOption {
          type = lib.types.path;
          description = "Path to the media directory.";
        };
      };
    };
  };

  flake.modules.nixos.arr = { pkgs, ... }: {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      profileDir = config.preferences.media.dir;
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