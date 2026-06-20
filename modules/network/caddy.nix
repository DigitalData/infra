{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.caddy = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email for ACME SSL.";
      };
      domain = lib.mkOption {
        type = lib.types.str;
        description = "The domain for this host.";
      };
      exposePorts = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Ports to expose via reverse proxy. So `key: port` becomes `key.domain -> localhost:port`.";
      };
    };
  };

  flake.modules.nixos.caddy = { lib, config, ... }: {

    # Caddy is a reverse proxy / HTTPS management service thing
    services.caddy = {
      enable = true;
      email = config.caddy.email;
      acmeCA = "internal";
      virtualHosts = lib.mapAttrs' (key: port: {
        name = "${key}.${config.caddy.domain}";
        value = {
          extraConfig = ''
            reverse_proxy localhost:${builtins.toString port}
          '';
        };
      }) config.caddy.exposePorts;
    };

    services.resolved.enable = true;
    services.tailscale.permitCertUid = lib.mkIf config.services.tailscale.enable "caddy";

  };

}