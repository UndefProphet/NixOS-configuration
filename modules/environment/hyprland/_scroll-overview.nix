{ lib, ... }:
{
  tack.inputs = {
    # hyprland-scroll-overview = "gh:yayuuu/hyprland-scroll-overview?ref=main";
    hyprland-phantomat = "gh:kaolti/phantomat?ref=main";
  };

  flake.modules.nixos.hyprland =
    {
      config,
      pkgs,
      inputs',
      ...
    }:

    let
      luaCode = # lua
        ''

          hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
          hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
        '';
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hm.wayland.windowManager.hyprland = {
          plugins = [
            inputs'.hyprland-scroll-overview.packages.scrolloverview
          ];
          extraLuaFiles."startup" = {
            autoLoad = true;
            content = luaCode;
          };
        };
      };
    };
}
