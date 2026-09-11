{ lib, ... }: {
  flake.modules.nixos.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.hyprland;
    in
    {

      options.conf.environment.hyprland = {
        enable = lib.mkEnableOption { };
      };

      config =
        lib.mkIf cfg.enable
        <| lib.mkMerge [
          {

            programs.hyprland = {
              enable = true;
              xwayland.enable = true;
              # portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
              # package = inputs'.hyprland.packages.hyprland;
              withUWSM = true;
            };

            hj.windowManagers.hyprland = {
              enable = true;

              features = {
                hyprmoncfg = {
                  enable = true;
                };
              };
            };

            # Wallpaper handler
            hj.programs.waypaper = {
              enable = true;
              backendPackages = [ pkgs.awww ];
              settingsEnforce = "copy";
              overridePrevious = true;
              settings =
                # let
                # waypaperdir = config.hj.xdg.configHome + "/waypaper";
                # in
                {
                  language = "en";
                  backend = "awww";
                  folder = "${config.hj.environment.sessionVariables.XDG_PICTURES_DIR}/wallpapers";
                  monitors = "All";
                  wallpaper = "${./wallpaper.png}";
                  show_path_in_tooltip = true;
                  fill = "fill";
                  sort = "daterev";
                  color = "#000000";
                  subfolders = true;
                  all_subfolders = false;
                  show_hidden = false;
                  show_gifs_only = false;
                  zen_mode = false;
                  post_command = "";
                  number_of_columns = 3;
                  swww_transition_type = "any";
                  swww_transition_step = 63;
                  swww_transition_angle = 0;
                  swww_transition_duration = 2;
                  swww_transition_fps = 60;
                  mpvpaper_sound = false;
                  mpvpaper_options = "";
                  use_xdg_state = false;
                };
            };
          }
        ];
    };
}
