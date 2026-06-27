{ ... } :
{

  # Run `tailscale login`
  # TODO: Encrypted auth key
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