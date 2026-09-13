{
  inputs,
  ...
}:
{
  # https://github.com/nix-community/disko
  # Disc partitioning and declaration
  tack.inputs.disko = "gh:nix-community/disko?ref=master";

  flake.modules.nixos.desktop = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = {
      disk = {

        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-INTENSO_SSD_1642403004000109";
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
                        swapfile.size = "16G";
                      };
                    };
                  };
                };
              };
            };
          };
        };

        home = {
          type = "disk";
          device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB480G4_BTWL310201WY480QGN";
          content = {
            type = "gpt";
            partitions = {
              home = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  subvolumes = {
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
  };
}
