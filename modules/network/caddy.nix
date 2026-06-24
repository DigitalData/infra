{ ... }:
{

  flake.modules.nixos.base = { lib, ... }: {
    options.caddy = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email for ACME SSL.";
      };
      private = {
        enable = lib.mkEnableOption "Serve on private domain?";
        domain = lib.mkOption {
          type = lib.types.str;
          description = "The internal domain for this host.";
        };
      };
      public = {
        enable = lib.mkEnableOption "Serve on public domain?";
        domain = lib.mkOption {
          type = lib.types.str;
          description = "The external domain for this host.";
        };
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
        lib.optionalAttrs (config.caddy.public.enable) (lib.mapAttrs' (key: port: {
          name = "https://${key}.${config.caddy.public.domain}";
          value = {
            extraConfig = ''
              reverse_proxy localhost:${builtins.toString port}
            '';
          };
        }) config.caddy.exposePorts)
        //
        lib.optionalAttrs (config.caddy.private.enable) (lib.mapAttrs' (key: port: {
          name = "${key}.${config.caddy.private.domain}";
          value = {
            extraConfig = ''
              reverse_proxy localhost:${builtins.toString port}
            '';
          };
        }) config.caddy.exposePorts);
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.tailscale.permitCertUid = lib.mkIf config.services.tailscale.enable "caddy";
  };

}