{ lib, ... }: {

  flake.modules.nixos.yazi-filechooser =
    {
      config,
      pkgs,
      ...
    }:
    {
      options.conf.environment.filechooser.yazi.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.environment.filechooser.yazi;
        in
        lib.mkIf cfg.enable {

          conf.terminal.yazi.enable = true;

          xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
            config = {
              common = {
                "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
              };

              niri = {
                default = lib.mkForce [ "gnome" ];
                "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
                "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
                "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
              };

              hyprland = {
                default = lib.mkForce [
                  "hyprland"
                  "gtk"
                ];
                "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
                "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
                "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
              };
            };
          };

          hm =
            { config, ... }:
            let
              yazi-wrapper = pkgs.writeShellScript "yazi-wrapper.sh" ''
                #!/usr/bin/env sh
                set -e

                if [ "$6" -ge 4 ]; then
                  set -x
                fi

                multiple="$1"
                directory="$2"
                save="$3"
                path="$4"
                out="$5"

                command="${lib.getExe pkgs.kitty} --app-id=FileChooser -e ${lib.getExe pkgs.yazi}"

                if [ "$save" = "1" ]; then
                  set -- --chooser-file="$out" "$path"
                elif [ "$directory" = "1" ]; then
                  set -- --chooser-file="$out" --cwd-file="$out"".1" "$path"
                elif [ "$multiple" = "1" ]; then
                  set -- --chooser-file="$out" "$path"
                else
                  set -- --chooser-file="$out" "$path"
                fi

                for arg in "$@"; do
                  escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
                  command="$command \"$escaped\""
                done

                sh -c "$command"

                if [ "$directory" = "1" ]; then
                  if [ ! -s "$out" ] && [ -s "$out"".1" ]; then
                    cat "$out"".1" > "$out"
                    rm "$out"".1"
                  else
                    rm "$out"".1"
                  fi
                fi
              '';
            in
            {
              xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI { } {
                filechooser = {
                  cmd = yazi-wrapper;
                  default_dir = "${config.home.homeDirectory}/downloads";
                  open_mode = "default";
                  save_mode = "default";
                  create_help_file = 1;
                };
              };
            };
        };
    };
}
