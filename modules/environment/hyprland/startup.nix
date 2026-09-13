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
          hl.on("hyprland.start", function () 
            hl.exec_cmd("waypaper --restore --backend awww")
            hl.exec_cmd(terminal)
            hl.exec_cmd("quickshell &")
            hl.exec_cmd("awww-daemon")
            hl.exec_cmd("pasytray")
            hl.exec_cmd("qpwgraph --minimized")
            hl.exec_cmd("vicinae server")
            hl.exec_cmd("blueman-applet")
          end)
        '';
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hm.wayland.windowManager.hyprland.extraLuaFiles."startup" = {
          autoLoad = true;
          content = luaCode;
        };
      };
    };
}
