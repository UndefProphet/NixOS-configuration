{
  inputs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # device = os;
        device = "/dev/disk/by-id/nvme-Sandisk_PC_SN5100S_SDFQNSM-1T00-1002_25459Q805473";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "@rootfs" = {
                    mountpoint = "/";
                  };
                  "@nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  "@swap" = {
                    mountpoint = "/.swapvol";
                    swap = {
                      # swapfile.size = swapSize;
                      swapfile.size = "32G";
                    };
                  };
                  "@home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
