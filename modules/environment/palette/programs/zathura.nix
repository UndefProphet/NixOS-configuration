{
  flake.modules.nixos.palette = { config, ... }: {

    hj.programs.zathura = {
      settings = with config.palette.baseColors.hex; ''
        set recolor true # Recolors the content
        set recolor-reverse-video true # Keeps image colors

        # Transparency: zathura accepts rgba(r,g,b,a), alpha 0 - 1
        set default-bg "${base00.withOpacity}"
        set recolor-lightcolor "rgba(0,0,0,0)"

        set recolor-darkcolor "${base05.normal}"

        # Window
        set default-fg "${base05.normal}"

        # Status bar
        set statusbar-bg "${base00.normal}"
        set statusbar-fg "${base05.normal}"

        # Command bar / completion
        set inputbar-bg "${base00.normal}"
        set inputbar-fg "${base05.normal}"
        set completion-bg "${base00.normal}"
        set completion-fg "${base05.normal}"
        set completion-group-bg "${base01.normal}"
        set completion-group-fg "${base05.normal}"
        set completion-highlight-bg "${base02.normal}"
        set completion-highlight-fg "${base06.normal}"

        # Text highlighting (search)
        set highlight-color "${base02.normal}"
        set highlight-fg "${base00.normal}"
        set highlight-active-color "${base09.normal}"

        # Index mode (file pager)
        set index-bg "${base00.normal}"
        set index-fg "${base05.normal}"
        set index-active-bg "${base02.normal}"
        set index-active-fg "${base00.normal}"

        # Notifications
        set notification-bg "${base00.normal}"
        set notification-fg "${base05.normal}"
        set notification-error-bg "${base00.normal}"
        set notification-error-fg "${base08.normal}"
        set notification-warning-bg "${base00.normal}"
        set notification-warning-fg "${base0a.normal}"

        # Rendering
        set render-loading-bg "${base00.normal}"
        set render-loading-fg "${base03.normal}"
      '';
    };
  };
}
