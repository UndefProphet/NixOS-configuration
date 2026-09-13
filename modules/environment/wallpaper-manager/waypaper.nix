{ lib, ... }: {

  flake.modules.nixos.waypaper =
    {
      config,
      pkgs,
      username,
      ...
    }:
    {
      options.conf.environment.wallpaper.waypaper.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.environment.wallpaper.waypaper;
        in
        lib.mkIf cfg.enable {
          users.users."${username}".packages = with pkgs; [
            waypaper
            awww
          ];

          hm =
            {
              config,
              lib,
              ...
            }:
            {
              home.activation.waypaperConfig =
                let
                  waypaperdir = config.xdg.configHome + "/waypaper";
                  wallpaperdir = config.xdg.userDirs.pictures + "/wallpapers";

                  default-settings = pkgs.writeText "waypaper" (
                    lib.generators.toINI { } {
                      Settings = {
                        language = "en";
                        backend = "awww";
                        folder = wallpaperdir;
                        monitors = "All";
                        wallpaper = "${./wallpaper.png}";
                        show_path_in_tooltip = true;
                        fill = "fill";
                        sort = "daterev";
                        color = "#ffffff";
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
                        # stylesheet = "${waypaperdir}/style.css";
                        # keybindings = "${waypaperdir}/keybindings.ini";
                      };
                    }
                  );
                in
                lib.hm.dag.entryAfter [ "WriteBoundry" ]
                  # Bash
                  ''
                    if [ ! -f "${waypaperdir}/config.ini" ]; then
                      mkdir -p "${waypaperdir}"
                      install -m 644 ${default-settings} "${waypaperdir}/config.ini"
                    fi
                  '';
            };
        };
    };
}
