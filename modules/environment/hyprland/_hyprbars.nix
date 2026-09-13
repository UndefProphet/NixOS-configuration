{ lib, ... }:
{
  flake.modules.nixos.hyprland =
    {
      config,
      pkgs,
      ...
    }:

    let
      luaCode = # lua
        ''
          hl.config({
            plugin = {
              hyprbars = {
                bar_height = 20,
                -- bar_color = "rgba(595959aa)",
                on_double_click = "hyprctl dispatch fullscreen 1",
              },
            },
          })

          hl.plugin.hyprbars.add_button({
            bg_color = "rgb(ff4040)",
            fg_color = "rgb(ffffff)",
            size = 10,
            icon = "X",
            action = "hyprctl dispatch 'hl.dsp.window.close()'",
          })

          hl.plugin.hyprbars.add_button({
            bg_color = "rgb(eeee11)",
            fg_color = "rgb(000000)",
            size = 10,
            icon = "_",
            action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
          })
        '';
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hm.wayland.windowManager.hyprland = {
          plugins = with pkgs.hyprlandPlugins; [
            hyprbars
          ];
          extraLuaFiles."startup" = {
            autoLoad = true;
            content = luaCode;
          };
        };
      };
    };
}
