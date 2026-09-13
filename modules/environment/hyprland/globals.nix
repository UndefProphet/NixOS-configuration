{ lib, ... }:
let
  luaCode = # lua
    ''
      terminal    = "kitty"
      fileManager = "kitty -e \"yazi\""
      menu        = "vicinae toggle"
      browser     = "glide"
    '';
in
{
  flake.modules.nixos.hyprland =
    {
      config,
      ...
    }:
    {
      config =
        let
          cfg = config.conf.environment.hyprland;
        in
        lib.mkIf cfg.enable {
          hm.wayland.windowManager.hyprland.extraLuaFiles."globals" = {
            autoLoad = true;
            content = luaCode;
          };
        };
    };
}
