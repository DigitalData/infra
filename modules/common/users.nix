{ config, pkgs, ... }:

{
  # System-level user definitions
  # Configure user accounts per host

  users.users.digitaldata = {
    isNormalUser = true;
    description = "digitaldata";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
}
