{ ... } :
{

  flake.modules.nixos.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--accept-dns=false"
      ];
    };
  };

}