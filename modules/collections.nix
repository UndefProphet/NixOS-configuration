{ lib, ... }: {
  flake.modules.nixos.collections =
    { config, ... }:
    let
      cfg = config.collections;
    in
    {
      options.collections = {
        core = lib.mkEnableOption { };
        terminal = lib.mkEnableOption { };
        graphical-environment = lib.mkEnableOption { };

        packages = {
          nix-utilities = lib.mkEnableOption { };
          generic = lib.mkEnableOption { };

          creative = {
            enable = lib.mkEnableOption { };
            audio = lib.mkEnableOption { };
            video = lib.mkEnableOption { };
            photography = lib.mkEnableOption { };
            recording = lib.mkEnableOption { };
          };

          gaming = lib.mkEnableOption { };
          wayland-utilities = lib.mkEnableOption { };
        };
      };

      config = lib.mkMerge [

        (lib.mkIf cfg.core {
          conf.system.nix.enable = lib.mkDefault true;
          conf.boot.grub.enable = lib.mkDefault true;
          conf.user.enable = lib.mkDefault true;
          conf.networking.enable = lib.mkDefault true;
        })

        (lib.mkIf cfg.terminal {
          conf.terminal = {
            fish.enable = true;
            kitty.enable = true;
          };
        })

        (lib.mkIf cfg.graphical-environment {
          conf.environment.hyprland.enable = lib.mkDefault true;
        })

        # Packages
        (lib.mkIf cfg.packages.generic { })
        (lib.mkIf cfg.packages.createive.enable {
          collections.packages.creative = {
            audio = lib.mkDefault true;
            video = lib.mkDefault true;
            photography = lib.mkDefault true;
            recording = lib.mkDefault true;
          };
        })
        (lib.mkIf cfg.packages.gaming { })
        (lib.mkIf cfg.packages.nix-utilities { })
        (lib.mkIf cfg.packages.wayland-utilities { })
      ];
    };
}
