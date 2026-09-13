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
          -- Helper functions
          local function tiledOrFloating(tiled, floating)
            return function()
              local activeWindow = hl.get_active_window()
              if not activeWindow then return end
              (activeWindow.floating and floating or tiled)(activeWindow)
            end
          end


          local mainMod = "SUPER" -- Sets "Windows" key as main modifier

          -- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
          hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
          local closeWindowBind = hl.bind(mainMod .. " + q", hl.dsp.window.close())

          -- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
          hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
          hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

          hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
          hl.bind(mainMod .. " + SHIFT + V", tiledOrFloating(
            function() hl.dispatch(hl.dsp.window.cycle_next({ floating = true, tiled = false})) end,
            function() hl.dispatch(hl.dsp.window.cycle_next({ floating = false, tiled = true })) end
          ))
          hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
          hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", layout_aware = false }))
          hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.tag({ tag = "hidden" }))

          hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
          hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
          hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
          hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

          local moveAmount = 200
          hl.bind(mainMod .. " + CTRL + H", tiledOrFloating(
            function() hl.dispatch(hl.dsp.layout("swapcol l")) end,
            function(window) hl.dispatch(hl.dsp.window.move({x = -moveAmount, y = 0, relative = true, window = window })) end
          ), { repeating = true })
          hl.bind(mainMod .. " + CTRL + L", tiledOrFloating(
            function() hl.dispatch(hl.dsp.layout("swapcol r")) end,
            function(window) hl.dispatch(hl.dsp.window.move({x = moveAmount, y = 0, relative = true, window = window })) end
          ), { repeating = true })
          hl.bind(mainMod .. " + CTRL + K", tiledOrFloating(
            function() hl.dispatch(hl.dsp.window.move({ direction = "up", group_aware = false })) end,
            function(window) hl.dispatch(hl.dsp.window.move({x = 0, y = -moveAmount, relative = true, window = window })) end
          ), { repeating = true })
          hl.bind(mainMod .. " + CTRL + J", tiledOrFloating(
            function() hl.dispatch(hl.dsp.window.move({ direction = "down", group_aware = false })) end,
            function(window) hl.dispatch(hl.dsp.window.move({x = 0, y = moveAmount, relative = true, window = window })) end
          ), { repeating = true })


          -- Scrolling
          hl.bind(mainMod .. " + BracketLeft", hl.dsp.layout("consume_or_expel prev"))
          hl.bind(mainMod .. " + BracketRight", hl.dsp.layout("consume_or_expel next"))
          hl.bind(mainMod .. " + period", hl.dsp.layout("consume"))
          hl.bind(mainMod .. " + comma", hl.dsp.layout("expel"))
          hl.bind(mainMod .. " + C", hl.dsp.layout("center"))

          -- Handle resize in scrolling and floating mode
          local resizeAmount = 200
          hl.bind(mainMod .. " + equal", tiledOrFloating(
            function() hl.dispatch(hl.dsp.layout("colresize +conf")) end,
            function() hl.dispatch(hl.dsp.window.resize({x = resizeAmount, y = 0, relative = true})) end
          ))
          hl.bind(mainMod .. " + minus", tiledOrFloating(
            function() hl.dispatch(hl.dsp.layout("colresize -conf")) end,
            function() hl.dispatch(hl.dsp.window.resize({x = -resizeAmount, y = 0, relative = true})) end
          ))
          hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({x = 0, y = resizeAmount, relative = true}))
          hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({x = 0, y = -resizeAmount, relative = true}))

          -- Switch workspaces with mainMod + [0-9]
          -- Move active window to a workspace with mainMod + SHIFT + [0-9]
          for i = 1, 10 do
            local key = i % 10 -- 10 maps to key 0
            hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
            hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
          end

          -- Example special workspace (scratchpad)
          hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
          hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

          -- Scroll through existing workspaces with mainMod + scroll
          hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
          hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

          -- Move/resize windows with mainMod + LMB/RMB and dragging
          hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
          hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

          -- Laptop multimedia keys for volume and LCD brightness
          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),    { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })
          hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true, repeating = true })
          hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { locked = true, repeating = true })
          hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} -e4 -n2 set 5%+"),  { locked = true, repeating = true })
          hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} -e4 -n2 set 5%-"),  { locked = true, repeating = true })

          hl.bind("XF86WLAN",             hl.dsp.exec_cmd("kitty --app-id=TuiConfigurator -e \"${lib.getExe pkgs.impala}\""))
          hl.bind("SUPER + P",            hl.dsp.exec_cmd("kitty --app-id=TuiConfigurator -e \"${pkgs.hyprmoncfg}/bin/hyprmoncfg\""))

          -- Requires playerctl
          hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
          hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
          hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
          hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
        '';
    in
    {
      config =
        let
          cfg = config.conf.environment.hyprland;
        in
        lib.mkIf cfg.enable {
          hm.wayland.windowManager.hyprland.extraLuaFiles."keybindings" = {
            autoLoad = true;
            content = luaCode;
          };
        };
    };
}
