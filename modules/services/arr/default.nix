{ self, inputs, lib, ... }:
{
  options.arr = lib.mkOption {
    description = "Configuration for arr services.";
    type = lib.types.submodule {
      options.mediaDir = lib.mkOption {
        type = lib.types.absolutePath;
        required = true;
        description = "Path to the arr media directory.";
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