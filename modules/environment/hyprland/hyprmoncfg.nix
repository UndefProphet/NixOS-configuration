{ lib, ... }:
{
  flake.modules.nixos.hyprland =
    {
      config,
      pkgs,
      ...
    }:

    let
      # -- hl.exec_cmd("${lib.getExe pkgs.pasytray}")
      luaCode = # lua
        ''
          -- Load monitors
          require("monitors")

          hl.on("hyprland.start", function () 
            hl.exec_cmd("${pkgs.hyprmoncfg}/bin/hyprmoncfgd")
          end)
        '';
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        hm =
          {
            config,
            lib,
            ...
          }:
          {

            home.shellAliases = {
              monitors = "${lib.getExe pkgs.hyprmoncfg} tui";
            };

            wayland.windowManager.hyprland.extraLuaFiles."hyprmoncfg" = {
              autoLoad = true;
              content = luaCode;
            };

            home.activation.hyprmoncfgInitConfig =
              let
                hyprlanddir = config.xdg.configHome + "/hypr";

                defaultConfig = pkgs.writeText "monitors" "";

              in
              lib.hm.dag.entryAfter [ "WriteBoundry" ] ''
                if [ ! -f "${hyprlanddir}/monitors.lua" ]; then
                  mkdir -p "${hyprlanddir}"
                  install -m 644 ${defaultConfig} "${hyprlanddir}/monitors.lua"
                fi
              '';

          };

      };
    };
}
