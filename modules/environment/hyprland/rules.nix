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
          -- Add gaps for special workspace
          hl.workspace_rule({
            workspace = "s[true]",
            gaps_out = hl.get_config("general.gaps_out").top + 40,
            gaps_in = hl.get_config("general.gaps_in").top + 20,
          })

          -- Hiden everything on the special workspace
          hl.window_rule({
            match = {
              workspace = "special:magic"
            },
            no_screen_share = true;
            border_color = "#fff033 #ff0d2d";
          })

          -- Hidden
          hl.window_rule({
            match = {
              tag = "hidden",
            },
            no_screen_share = true;
            border_color = "#fff033 #ff0d2d";
          })

          local hideClass = {
            "org.keepassxc.KeePassXC",
            "equibop"
          }

          local function contains(tbl, value)
            for _, v in ipairs(tbl) do
              if v == value then
                return true
              end
            end
            return false
          end

          -- Using window rule to set tag makes it impossible to remove the tag!
          hl.on("window.open", function(win)
            if win ~= nil and contains(hideClass, win.class) then
              hl.dispatch(hl.dsp.window.tag({ tag = "+hidden", window = win}))
            end
          end)





          hl.window_rule({
            match = {
              title = "Select what to share",
            },
            float = true,
            center = true,
            size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
          })

          hl.window_rule({
            match = {
              class = "FileChooser",
            },
            float = true,
            center = true,
            size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
          })

          hl.window_rule({
            match = {
              class = "TuiConfigurator",
            },
            float = true,
            center = true,
            size = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
          })

          -- Example window rules that are useful

          local suppressMaximizeRule = hl.window_rule({
              -- Ignore maximize requests from all apps. You'll probably like this.
              name  = "suppress-maximize-events",
              match = { class = ".*" },

              suppress_event = "maximize",
          })
          -- suppressMaximizeRule:set_enabled(false)

          hl.window_rule({
              -- Fix some dragging issues with XWayland
              name  = "fix-xwayland-drags",
              match = {
                  class      = "^$",
                  title      = "^$",
                  xwayland   = true,
                  float      = true,
                  fullscreen = false,
                  pin        = false,
              },

              no_focus = true,
          })
        '';
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hm.wayland.windowManager.hyprland.extraLuaFiles."rules" = {
          autoLoad = true;
          content = luaCode;
        };
      };
    };
}
