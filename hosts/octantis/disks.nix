{
  flake.diskoConfigurations.octantis = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-Corsair_Neutron_GTX_SSD_130479140000971401BB";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };

              swap = {
                size = "8G";
                content = {
                  type = "swap";
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };
                  };
                };
              };
            };
          };
        };

        data1 = {
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
    };
  };
}