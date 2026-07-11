## New disk on existing system

1. Ensure all other disks on host have `destroy: false;` in `disks.nix`.
```nix
{
  flake.diskoConfigurations.octantis = {
    disko.devices = {
      disk = {
        ...
        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-Corsair_Neutron_GTX_SSD_abcd1234";
          destroy = false;
          ...
```
2. Add new disk to `disks.nix` with `destroy: true;`.
3. Run the following command to format and mount the new disk:
```bash
sudo nix run github:nix-community/disko/latest -- --mode format,mount --flake .#$(hostname)
```
4. If you want to destroy the new disk, run the following command:
```bash
sudo nix run github:nix-community/disko/latest -- --mode destroy --flake .#$(hostname)
```

## Change disk mount point

1. Update mount point in `disks.nix`.
2. Run the following command to apply the changes:
```bash
sudo nix run github:nix-community/disko/latest -- --mode mount --flake .#$(hostname)
```