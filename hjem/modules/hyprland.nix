{ lib, ... }:
{
  flake.modules.hjem-modules.hyprland =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.windowManagers.hyprland;

    in
    {
      options.windowManagers.hyprland = {

        enable = lib.mkEnableOption {
          description = "Enable hyprland.";
        };

        package = lib.mkPackageOption pkgs "hyprland" {
          nullable = true;
          extraDescription = "Set this to null if you use the NixOS module to install Hyprland.";
        };

        portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-hyprland" {
          nullable = true;
        };

        sections = {

          globals = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Global values access from everywhere.";
          };

          startup = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Function body of 
              hl.on("hyprland.start", function () 
              ...
              end)
            '';
          };

          content = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Main body written in lua";
          };

          keybindings = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Keybindings written in lua";
          };

          rules = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Rules written in lua";
          };

          extra = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Rules written in lua";
          };
        };

        features = {

          hyprmoncfg = {

            enable = lib.mkEnableOption {
              default = true;
              description = "Enable monitor management through hyprmoncfg.";
            };

            package = lib.mkPackageOption pkgs "hyprmoncfg" {
              nullable = true;
              extraDescription = "Set this to null if you use the Hjem module to install hyprmoncfg.";
            };
          };
        };

        plugins = { };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {

            assertions =
              let
                luaOf = section: if section == null then "" else section;
              in
              [
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.globals);
                  message = "windowManagers.hyprland.startup is not valid Lua";
                }
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.startup);
                  message = "windowManagers.hyprland.startup is not valid Lua";
                }
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.content);
                  message = "windowManagers.hyprland.content is not valid Lua";
                }
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.keybindings);
                  message = "windowManagers.hyprland.keybindings is not valid Lua";
                }
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.rules);
                  message = "windowManagers.hyprland.rules is not valid Lua";
                }
                {
                  assertion = lib.validators.validateLua (luaOf cfg.sections.extra);
                  message = "windowManagers.hyprland.extra is not valid Lua";
                }
              ];

            packages = lib.mkMerge [
              (lib.optional cfg.features.hyprmoncfg.enable cfg.features.hyprmoncfg.package)
            ];

            xdg.config.files."hypr/monitors.lua" = {
              type = "copy";
              clobber = false;
              text = "";
            };

            xdg.config.files."hypr/hyprland.lua".text = # lua
              ''
                  ---- GLOBAL VALUES ----
                  ${lib.optionalString (cfg.sections.globals != null) cfg.sections.globals}
                  ${lib.optionalString cfg.features.hyprmoncfg.enable "require(\"monitors\")"}

                ---- STARTUP ----
                hl.on("hyprland.start", function () 
                  ${lib.optionalString (cfg.sections.content != null) cfg.sections.startup}
                  ${lib.optionalString cfg.features.hyprmoncfg.enable "hl.exec_cmd(\"hyprmoncfgd\")"}
                end)

                  ---- LOOK AND FEEL ----
                  ${lib.optionalString (cfg.sections.content != null) cfg.sections.content}

                  ---- KEYBINDINGS ----
                  ${lib.optionalString (cfg.sections.keybindings != null) cfg.sections.keybindings}

                  ---- extra ----
                  ${lib.optionalString (cfg.sections.extra != null) cfg.sections.extra}
              '';

            environment.sessionVariables = {
              MOZ_ENABLE_WAYLAND = "1";
            };
          }
        ]
      );
    };
}
