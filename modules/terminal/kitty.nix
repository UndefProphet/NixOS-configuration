{ lib, ... }: {
  flake.modules.nixos.kitty =
    {
      config,
      ...
    }:
    let
      cfg = config.conf.terminal.kitty;
    in
    {
      options.conf.terminal.kitty.enable = lib.mkEnableOption {
        description = "Enable fish shell";
      };

      config = lib.mkIf cfg.enable {
        hm = {

          programs.kitty = {
            enable = true;
            settings = with config.palette.colors.hex.terminal; {
              window_padding_width = 10;
              confirm_os_window_close = 0;
              font_size = 9.0;
              background_opacity = config.palette.opacity;

              # Foreground / background
              foreground = foreground.normal;
              background = background.normal;
              selection_foreground = foreground.normal;
              selection_background = selection-background.normal;
              cursor = light-foreground.normal;
              cursor_text_color = background.normal;
              url_color = cyan.normal;

              # ANSI colors
              color0 = background.normal;
              color1 = red.normal;
              color2 = green.normal;
              color3 = yellow.normal;
              color4 = blue.normal;
              color5 = purple.normal;
              color6 = cyan.normal;
              color7 = foreground.normal;
              color8 = comments.normal;
              color9 = bright-red.normal;
              color10 = bright-green.normal;
              color11 = bright-yellow.normal;
              color12 = bright-blue.normal;
              color13 = purple.normal;
              color14 = bright-cyan.normal;
              color15 = lightest-foreground.normal;

              # Tabs
              active_tab_foreground = foreground.normal;
              active_tab_background = background.normal;
              inactive_tab_foreground = suggestion.normal;
              inactive_tab_background = lighter-background.normal;

              # Borders
              active_border_color = selection-background.normal;
              inactive_border_color = lighter-background.normal;
              bell_border_color = comments.normal;
            };
          };

          # TODO: move to kitty
          xdg.terminal-exec = {
            enable = true;
            settings = {
              default = [
                "kitty.desktop"
              ];
            };
          };
        };
      };
    };
}
