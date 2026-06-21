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
    
    systemd.services.tailscale.after = [ "network-online.target" ];
    systemd.services.tailscale.wants = [ "network-online.target" ];
  };

}