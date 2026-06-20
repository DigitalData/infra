{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.media = {
      arr = lib.mkEnableOption "*arr services";
      jelly = lib.mkEnableOption "Jelly* services";
      users.user = lib.mkOption {
        type = lib.types.str;
        description = "User for media services.";
        default = "media";
      };
      users.group = lib.mkOption {
        type = lib.types.str;
        description = "User group for media services.";
        default = "media";
      };
      dir.data = lib.mkOption {
        type = lib.types.str;
        description = "Path to the profile data directory.";
      };
      dir.media = lib.mkOption {
        type = lib.types.str;
        description = "Path to the media directory.";
      };
      dir.torrents = lib.mkOption {
        type = lib.types.str;
        description = "Path to the torrent directory.";
      };
    };
  };

  flake.modules.nixos.media = { config }: {
    users.users.${config.media.users.user} = {
      isSystemUser = true;
      group = config.media.users.group;
      createHome = false;
    };
    users.groups.${config.media.users.group} = {};
  };

}