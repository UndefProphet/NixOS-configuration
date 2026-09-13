{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.conf.terminal.yazi.enable {
    hm = {
      programs.yazi = {
        plugins = with pkgs.yaziPlugins; {
          mux = {
            package = mkYaziPlugin {
              pname = "mux-yazi";
              name = "mux-yazi";
              version = "1.0";
              src = pkgs.fetchFromGitHub {
                owner = "peterfication";
                repo = "mux.yazi";
                rev = "e4e67713d5043fb7a25491cf4a29ee51e556f32e";
                hash = "sha256-Cf/gtv3uIwXtkp6pEZJSkylA3vHpmQqrWOLo2FLg9yA=";
              };
            };
            setup = true;
            settings = {
              aliases =
                let
                  eza_level = level: {
                    "eza_tree_${toString level}" = {
                      previewer = "piper";
                      args = [
                        ''${lib.getExe pkgs.eza} --color=always --icons=always --no-quotes -TL=${toString level} -l --git --no-permissions --no-user --no-filesize --no-time --group-directories-first "$1"/''
                      ];
                    };
                  };
                in
                lib.mergeAttrsList (
                  map eza_level [
                    1
                    2
                    3
                    4
                  ]
                );
            };
          };
        };

        keymap = {
          mgr.prepend_keymap = [
            {
              on = [ "P" ];
              run = "plugin mux next";
              desc = "Show or hide ...";
            }
          ];
        };

        settings = {
          mgr.prepend_keymap = [
            {
              on = [ "P" ];
              run = "plugin mux next";
              desc = "Show or hide ...";
            }
          ];

          plugin.prepend_previewers = [
            {
              url = "*/";
              run = "mux eza_tree_2 eza_tree_3 eza_tree_4 eza_tree_1";
            }
          ];
        };
      };
    };
  };
}
