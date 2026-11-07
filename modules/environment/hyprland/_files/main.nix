{ lib, pkgs, ... }: {
  name = "main";
  order = 2;
  content = # lua
    ''
      -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
      hl.config({
        general = {
            gaps_in  = 0,
            gaps_out = 0,
            border_size = 2,
            col = {
                -- active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
                active_border   = { colors = {focusColor, focusColor}, angle = 45 },
                inactive_border = unfocusColor,
            },
            resize_on_border = true,
            allow_tearing = false,
            layout = "scrolling",
        },

        decoration = {
            rounding = 0,
            active_opacity = 1.0,
            inactive_opacity = 1.0,
            dim_special = 0.5,
            shadow = {
                enabled = true,
                range = 4,
                render_power = 3,
                color = 0xee1a1a1a,
            },
            blur = {
                enabled = true,
                size = 3,
                passes = 3,
                vibrancy = 0.1696,
            },
        },
      })

      hl.config({
        scrolling = {
          fullscreen_on_one_column = false,
          explicit_column_widths = "0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0",
          column_width = "0.3",
        };
      });
    '';
}
