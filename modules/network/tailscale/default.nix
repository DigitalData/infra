{ ... } :
{

  flake.modules.nixos.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--accept-dns=false"
        "--advertise-routes=192.168.86.0/24"
      ];
    };
  };

}