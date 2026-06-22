{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.caddy = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email for ACME SSL.";
      };
      domain.private = lib.mkOption {
        type = lib.types.str;
        description = "The internal domain for this host.";
      };
      domain.public = lib.mkOption {
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
      virtualHosts = 
        # # External routes (Let's Encrypt)
        # (lib.mapAttrs' (key: port: {
        #   name = "https://${key}.${config.caddy.domain.public}";
        #   value = {
        #     extraConfig = ''
        #       reverse_proxy localhost:${builtins.toString port}
        #     '';
        #   };
        # }) config.caddy.exposePorts)
        # //
        # Internal routes (Internal TLS)
        (lib.mapAttrs' (key: port: {
          name = "${key}.${config.caddy.domain.private}";
          value = {
            extraConfig = ''
              reverse_proxy localhost:${builtins.toString port}
            '';
          };
        }) config.caddy.exposePorts);
      
    };

    services.tailscale.permitCertUid = lib.mkIf config.services.tailscale.enable "caddy";
  };

}