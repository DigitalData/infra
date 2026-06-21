{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.caddy = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email for ACME SSL.";
      };
      domain.internal = lib.mkOption {
        type = lib.types.str;
        description = "The internal domain for this host.";
      };
      domain.external = lib.mkOption {
        type = lib.types.str;
        description = "The external domain for this host.";
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
      # acmeCA = "internal"; # internal CA for my internal routes
      globalConfig = ''
        # Explicitly bind to all interfaces for both Tailscale and LAN access
        http_port 80
        https_port 443
      '';
      virtualHosts = let
        mkVirtualHost = domain: key: port: {
          name = "${key}.${domain}";
          value = {
            extraConfig = if domain == config.caddy.domain.internal then ''
              tls internal {
                # Use internal cert, don't manage/sign it
              }
              reverse_proxy localhost:${builtins.toString port}
            '' else ''
              reverse_proxy localhost:${builtins.toString port}
            '';
          };
        };
        mkDomainsForPort = key: port: [
          (mkVirtualHost config.caddy.domain.internal key port)
          (mkVirtualHost config.caddy.domain.external key port)
        ];
        in lib.listToAttrs (lib.flatten (lib.mapAttrsToList mkDomainsForPort config.caddy.exposePorts));
    };

    services.tailscale.permitCertUid = lib.mkIf config.services.tailscale.enable "caddy";
  };

}