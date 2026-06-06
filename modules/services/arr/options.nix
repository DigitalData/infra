{ lib, ... }:
{
  options.media = lib.mkOption {
    description = "Configuration for arr services.";
    type = lib.types.submodule {
      options.dir = lib.mkOption {
        type = lib.types.path;
        description = "Path to the arr media directory.";
      };
    };
  };
}