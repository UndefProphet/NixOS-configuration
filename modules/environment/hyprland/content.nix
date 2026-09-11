{ lib, ... }: {
  flake.modules.nixos.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.windowManagers.hyprland.sections.content = # lua
          ''
            -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
            hl.config({
                general = {
                    gaps_in  = 5,
                    gaps_out = 20,
                    border_size = 3,
                    col = {
                        active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
                        inactive_border = "rgba(595959aa)",
                    },
                    resize_on_border = true,
                    allow_tearing = false,
                    layout = "scrolling",
                },

                decoration = {
                    rounding       = 0,
                    active_opacity   = 1.0,
                    inactive_opacity = 1.0,
                    shadow = {
                        enabled      = true,
                        range        = 4,
                        render_power = 3,
                        color        = 0xee1a1a1a,
                    },
                    blur = {
                        enabled   = true,
                        size      = 3,
                        passes    = 1,
                        vibrancy  = 0.1696,
                    },
                },
            })
          '';
      };
    };
}
