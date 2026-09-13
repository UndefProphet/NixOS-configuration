{ lib, ... }: {
  flake.modules.nixos.fish =
    {
      config,
      username,
      pkgs,
      ...
    }:
    {

      options.conf.terminal.fish.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.terminal.fish;
        in
        lib.mkIf cfg.enable {
          users.users."${username}".shell = pkgs.fish;
          programs.fish.enable = true;

          hm = {

            programs.fish = {
              enable = true;
              functions = {
                fish_greeting = "";
              };

              interactiveShellInit = with config.palette.colors.hex.terminal; ''
                # Syntax highlighting
                set -g fish_color_normal "${foreground.withoutHash}"
                set -g fish_color_command "${green.withoutHash}"
                set -g fish_color_keyword "${red.withoutHash}"
                set -g fish_color_quote "${yellow.withoutHash}"
                set -g fish_color_redirection "${cyan.withoutHash}"
                set -g fish_color_end "${orange.withoutHash}"
                set -g fish_color_error "${red.withoutHash}"
                set -g fish_color_param "${foreground.withoutHash}"
                set -g fish_color_comment "${comments.withoutHash}"
                set -g fish_color_selection "--background=${selection-background.withoutHash}"
                set -g fish_color_search_match "--background=${lighter-background.withoutHash}"
                set -g fish_color_operator "${cyan.withoutHash}"
                set -g fish_color_escape "${purple.withoutHash}"
                set -g fish_color_autosuggestion "${suggestion.withoutHash}"

                # Completion pager
                set -g fish_pager_color_progress "${comments.withoutHash}"
                set -g fish_pager_color_prefix "${cyan.withoutHash}"
                set -g fish_pager_color_completion "${foreground.withoutHash}"
                set -g fish_pager_color_description "${comments.withoutHash}"
                set -g fish_pager_color_selected_background "--background=${selection-background.withoutHash}"
                set -g fish_pager_color_selected_prefix "${cyan.withoutHash}"
                set -g fish_pager_color_selected_completion "${foreground.withoutHash}"
                set -g fish_pager_color_selected_description "${light-foreground.withoutHash}"
              '';
            };
          };
        };
    };
}
