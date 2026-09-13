{ lib, ... }: {
  flake.modules.nixos.collections =
    { config, pkgs, ... }:
    let
      cfg = config.collections;
    in
    {
      options.collections = {
        core = lib.mkEnableOption { };
        terminal = lib.mkEnableOption { };
        graphical-environment = lib.mkEnableOption { };

        packages = {
          nix-utilities = {
            enable = lib.mkEnableOption { };
          };
          generic = {
            enable = lib.mkEnableOption { };
          };

          creative = {
            enable = lib.mkEnableOption { };
            audio = lib.mkEnableOption { };
            video = lib.mkEnableOption { };
            photography = lib.mkEnableOption { };
            recording = lib.mkEnableOption { };
          };

          gaming = {
            enable = lib.mkEnableOption { };
          };
          wayland-utilities = {
            enable = lib.mkEnableOption { };
          };
        };
      };

      config = lib.mkMerge [

        (lib.mkIf cfg.core {
          conf.system.nix.enable = lib.mkDefault true;
          conf.boot.grub.enable = lib.mkDefault true;
          conf.networking.enable = lib.mkDefault true;
          conf.user.enable = lib.mkDefault true;
          conf.system.sudo-rs.enable = lib.mkDefault true;
          conf.system.audio.enable = lib.mkDefault true;
          conf.system.kmscon.enable = lib.mkDefault true;
        })

        (lib.mkIf cfg.terminal {
          conf.terminal = {
            # Core terminal
            shell-environment.enable = lib.mkDefault true;
            fish.enable = lib.mkDefault true;
            kitty.enable = lib.mkDefault true;

            # packages
            git.enable = lib.mkDefault true;
            tmux.enable = lib.mkDefault true;
            yazi.enable = lib.mkDefault true;
          };
          conf.packages.yt-dlp.enable = lib.mkDefault true;
          conf.packages.neovim.enable = lib.mkDefault true;
          conf.packages.opencode.enable = lib.mkDefault true;
        })

        (lib.mkIf cfg.graphical-environment {
          conf.environment.desktop-manager.greetd.enable = lib.mkDefault true;
          conf.environment.hyprland.enable = lib.mkDefault true;
          conf.environment.filechooser.yazi.enable = true;
          conf.environment.qt.enable = lib.mkDefault true;
        })

        # Packages
        (lib.mkIf cfg.packages.generic.enable {
          conf.packages = {
            firefox.enable = lib.mkDefault true;
            discord.enable = lib.mkDefault true;
            spotify.enable = lib.mkDefault true;
            thunderbird.enable = lib.mkDefault true;
            zathura.enable = lib.mkDefault true;

            obs.enable = lib.mkDefault true;
          };

          hm.home.packages = with pkgs; [
            qpwgraph
            vicinae
            keepassxc
            vlc
          ];
        })

        (lib.mkIf cfg.packages.creative.enable {
          collections.packages.creative = {
            audio = lib.mkDefault true;
            video = lib.mkDefault true;
            photography = lib.mkDefault true;
            recording = lib.mkDefault true;
          };
          hm.home.packages = with pkgs; [
            gimp
          ];
        })

        (lib.mkIf cfg.packages.gaming.enable {
          conf.packages = {
            # steam.enable = lib.mkDefault true;
            gaming.enable = lib.mkDefault true;
          };
        })

        (lib.mkIf cfg.packages.nix-utilities.enable {
          conf.packages = {
            comma.enable = lib.mkDefault true;
          };
        })

        (lib.mkIf cfg.packages.wayland-utilities.enable { })
      ];
    };
}
