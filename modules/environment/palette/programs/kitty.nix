{
  flake.modules.nixos.palette = { config, ... }: {

    hj.programs.kitty = {
      settings =
        with config.palette.baseColors.hex;
        with config.palette.fonts;
        {

          # Sizes
          window_padding_width = 10;
          font_size = sizes.terminal;

          # misc
          background_opacity = 0.85;

          # Colors
          background = base00.normal;
          foreground = base05.normal;
          selection_background = base05.normal;
          selection_foreground = base00.normal;
          url_color = base04.normal;
          cursor = base05.normal;
          active_border_color = base03.normal;
          inactive_border_color = base01.normal;
          active_tab_background = base00.normal;
          active_tab_foreground = base05.normal;
          inactive_tab_background = base01.normal;
          inactive_tab_foreground = base04.normal;

          ## normal
          color0 = base01.normal;
          color1 = base08.normal;
          color2 = base0b.normal;
          color3 = base09.normal;
          color4 = base0d.normal;
          color5 = base0e.normal;
          color6 = base0c.normal;
          color7 = base06.normal;

          ## bright
          color8 = base02.normal;
          color9 = base12.normal;
          color10 = base14.normal;
          color11 = base13.normal;
          color12 = base16.normal;
          color13 = base17.normal;
          color14 = base15.normal;
          color15 = base07.normal;

        };
    };
  };
}
