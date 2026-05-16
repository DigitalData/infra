{
  disko.devices = {
    disk_root = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Corsair_Neutron_GTX_SSD_130479140000971401BB";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            priority = 1;
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "8G";
            content = {
              type = "swap";
              randomEncryption = true;
              priority = 100;
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Override existing partition
              mountpoint = "/";
            };
          };
        };
      };
    };

    disk_data = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST2000DM001-1CH164_Z1E3253L";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}