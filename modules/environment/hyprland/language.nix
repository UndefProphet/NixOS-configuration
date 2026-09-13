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
          hl.config({
              input =  {
                  kb_layout = "us,se",
                  kb_variant = "",
                  kb_options = "grp:alt_shift_toggle"
              }
          })
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
