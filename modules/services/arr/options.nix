{ lib, ... }:
{
  options.arr = lib.mkOption {
    description = "Configuration for arr services.";
    type = lib.types.submodule {
      options.mediaDir = lib.mkOption {
        type = lib.types.path;
        description = "Path to the arr media directory.";
      };
    };
  };
}