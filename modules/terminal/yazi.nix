{ lib, ... }: {

  flake.modules.nixos.yazi = { config, pkgs, ... }: {

    imports = [
      ./_yazi/git.nix
      ./_yazi/mux.nix
    ];

    options.conf.terminal.yazi.enable = lib.mkEnableOption { };

    config =
      let
        cfg = config.conf.terminal.yazi;

        # styling.md mnemonic mapping:
        #   normal fg/bg      -> foreground / background
        #   inactive/borders  -> comments (base03)
        #   selected/hovered  -> bg selection-background, fg foreground
        #   focused           -> bg blue (base0D), fg background
        #   alert             -> red (base08)
        #   warning           -> brown (base0F)
        #   matching          -> light-foreground (base06)
        inherit (config.palette.colors.hex.mnemonic)
          background
          lighter-background
          selection-background
          comments
          dark-foreground
          foreground
          light-foreground
          red
          orange
          yellow
          green
          cyan
          blue
          purple
          brown
          ;
      in
      lib.mkIf cfg.enable {

        hm = { config, ... }: {
          programs.yazi = {
            enable = true;
            shellWrapperName = "Y";

            plugins = with pkgs.yaziPlugins; {
              inherit piper;
              inherit toggle-pane;

              starship = {
                package = starship;
                setup = true;
                settings = {
                  config_file = config.programs.starship.configPath;
                };
              };

              full-border = {
                package = full-border;
                setup = true;
                settings = {
                  type = lib.mkLuaInline "ui.Border.PLAIN";
                };
              };

              ouch = {
                package = ouch;
                setup = false;
              };
            };

            settings = {
              mgr = {
                ratio = [
                  2
                  3
                  5
                ];
                sort_dir_first = true;
                # linemode = "size_and_mtime";
              };

              plugin.prepend_previewers =
                let
                  bat = "${lib.getExe pkgs.bat} -p --color=always --theme base16";
                  qemu-img = lib.getExe' pkgs.qemu-utils "qemu-img";
                in
                with pkgs;
                [
                  {
                    url = "*.md";
                    run = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe glow} -w=$w -s=dark -- "$1"'';
                  }
                  {
                    mime = "text/*";
                    run = ''piper -- ${bat} "$1"'';
                  }
                  {
                    mime = "*/{xml,javascript,x-wine-extension-ini}";
                    run = ''piper -- ${bat} "$1"'';
                  }
                  {
                    url = "*.qcow2";
                    run = ''piper -- ${qemu-img} info "$1" | ${bat} -l asa'';
                  }
                  {
                    url = "*.txt.gz";
                    run = ''piper -- ${lib.getExe gzip} -dc "$1"'';
                  }
                  {
                    mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                    run = "ouch --show-file-icons";
                  }
                ];

              plugin.append_previewers = [
                {
                  url = "*";
                  run = ''piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
                }
              ];
            };

            theme = {
              mgr = {
                cwd = {
                  fg = comments.normal;
                };

                hovered = {
                  fg = foreground.normal;
                  bg = selection-background.normal;
                };
                preview_hovered = {
                  fg = foreground.normal;
                  bg = selection-background.normal;
                };

                find_keyword = {
                  fg = light-foreground.normal;
                  bold = true;
                };
                find_position = {
                  fg = light-foreground.normal;
                  bg = background.normal;
                };

                border_symbol = "│";
                border_style = {
                  fg = comments.normal;
                };
              };

              status = {
                mode_normal = {
                  fg = background.normal;
                  bg = blue.normal;
                };
                mode_select = {
                  fg = background.normal;
                  bg = purple.normal;
                };
                mode_unset = {
                  fg = background.normal;
                  bg = comments.normal;
                };

                progress_label = {
                  fg = foreground.normal;
                  bg = lighter-background.normal;
                };
                progress_normal = {
                  fg = blue.normal;
                  bg = lighter-background.normal;
                };
                progress_error = {
                  fg = red.normal;
                  bg = lighter-background.normal;
                };

                permissions_t = {
                  fg = comments.normal;
                };
                permissions_r = {
                  fg = green.normal;
                };
                permissions_w = {
                  fg = red.normal;
                };
                permissions_x = {
                  fg = yellow.normal;
                };

                selected = {
                  fg = blue.normal;
                };
                copied = {
                  fg = green.normal;
                };
                cut = {
                  fg = red.normal;
                };
              };

              input = {
                border_style = {
                  fg = comments.normal;
                };
                value = {
                  fg = foreground.normal;
                };
                selected = {
                  bg = selection-background.normal;
                };
              };

              select = {
                border_style = {
                  fg = comments.normal;
                };
                active = {
                  fg = foreground.normal;
                  bg = selection-background.normal;
                };
                inactive = {
                  fg = dark-foreground.normal;
                };
              };

              completion = {
                border_style = {
                  fg = comments.normal;
                };
                active = {
                  fg = foreground.normal;
                  bg = selection-background.normal;
                };
                inactive = {
                  fg = dark-foreground.normal;
                };
              };

              tasks = {
                border_style = {
                  fg = comments.normal;
                };
                hovered = {
                  fg = foreground.normal;
                  bg = selection-background.normal;
                };
                title = {
                  fg = blue.normal;
                };
              };

              which = {
                mask = {
                  bg = background.normal;
                };
                cand = {
                  fg = blue.normal;
                };
                rest = {
                  fg = comments.normal;
                };
                desc = {
                  fg = comments.normal;
                };
                separator_style = {
                  fg = comments.normal;
                };
                selected_style = {
                  fg = light-foreground.normal;
                  bg = selection-background.normal;
                };
              };

              notify = {
                title_ok = {
                  fg = green.normal;
                };
                title_info = {
                  fg = blue.normal;
                };
                title_warn = {
                  fg = yellow.normal;
                };
                title_error = {
                  fg = red.normal;
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

            # initLua =
            #   # lua
            #   ''
            #     function Linemode:size_and_mtime()
            #       local time = math.floor(self._file.cha.mtime or 0)
            #       if time == 0 then
            #         time = ""
            #       elseif os.date("%Y", time) == os.date("%Y") then
            #         time = os.date("%b %d %H:%M", time)
            #       else
            #         time = os.date("%b %d  %Y", time)
            #       end
            #       local size = self._file:size()
            #       return string.format("%s %s", size and ya.readable_size(size) or "-", time)
            #     end
            #   '';

            keymap = {
              mgr.prepend_keymap = [
                {
                  on = [ "T" ];
                  run = "plugin toggle-pane min-parent";
                  desc = "Show or hide ...";
                }
              ];
            };
          };
        };
      };
  };
}
