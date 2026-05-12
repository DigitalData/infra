{ config, pkgs, ... }:

{
  # System-level user definitions
  # Configure user accounts per host

  users.users.root = {
    initialPassword = "rootpass";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILk4bC/9jWdrMGhuJTfIVpc+YyEULpFKaGQHIL2sRtV8 octantis"
    ];
  };

  users.users.digitaldata = {
    isNormalUser = true;
    description = "digitaldata";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];

    # Add your development machine's public SSH key here so you can log in
    # without a password. Replace this placeholder with the actual key.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILk4bC/9jWdrMGhuJTfIVpc+YyEULpFKaGQHIL2sRtV8 octantis"
    ];
  };
}
