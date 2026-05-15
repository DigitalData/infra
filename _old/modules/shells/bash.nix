{ config, pkgs, hostname, isLinux ? false, ... }:

{
  # Bash shell configuration with rebuild alias
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = 
        let
          rebuilder = if isLinux then "nixos-rebuild" else "darwin-rebuild";
          flakePath = "/etc/nixos";
        in
        "cd ${flakePath}/hosts/${hostname} && ${rebuilder} switch --flake ../..";
    };
  };
}
