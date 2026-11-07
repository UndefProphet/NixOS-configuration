{ lib, ... }: {
  flake.modules.nixos.fish =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.programs.yazi;
    in
    {
      options.conf.programs.yazi = {

        enable = lib.mkEnableOption {
          description = "Enable yazi";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.yazi = {
          enable = true;
          settings = {
            yazi = {
              mgr = {
                ratio = [
                  2
                  3
                  5
                ];
                sort_dir_first = true;
                # linemode = "size_and_mtime";
              };
            };

            theme = {

              mgr = {
                border_style = {
                  crossed = true;
                };
              };

              indicator = {
                padding = {
                  open = "▐";
                  close = "▌";
                };
              };

              status = {
                sep_right = {
                  open = "▐";
                  close = "";
                };
                sep_left = {
                  open = "";
                  close = "▌";
                };
              };
            };
          };

          # plugins = with pkgs.yaziPlugins; {
          #   inherit piper;
          #   inherit toggle-pane;
          #
          #   starship = {
          #     package = starship;
          #     setup = true;
          #     settings = {
          #       config_file = config.programs.starship.configPath;
          #     };
          #   };
          #
          #   full-border = {
          #     package = full-border;
          #     setup = true;
          #     settings = {
          #       type = lib.mkLuaInline "ui.Border.PLAIN";
          #     };
          #   };
          #
          #   ouch = {
          #     package = ouch;
          #     setup = false;
          #   };
          # };
        };
      };
    };
}
