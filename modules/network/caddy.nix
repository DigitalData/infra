{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.caddy = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email for ACME SSL.";
      };
    };
  };

  flake.modules.nixos.caddy = { lib, config, ... }: {
    # Caddy is a reverse proxy / HTTPS management service thing
    services.caddy = {
      enable = true;
      email = config.caddy.email;
    };

    services.tailscale.permitCertUid = lib.mkIf config.services.tailscale.enable "caddy";
  };


}