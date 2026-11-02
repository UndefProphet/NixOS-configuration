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
      options.windowManagers.hyprland =
        with lib.types;
        with lib;
        {
          enable = mkEnableOption {
            description = "Enable hyprland.";
          };

          package = mkPackageOption pkgs "hyprland" {
            extraDescription = "Set this to null if you use the NixOS module to install Hyprland.";
            nullable = true;
          };

          portalPackage = mkPackageOption pkgs "xdg-desktop-portal-hyprland" {
            nullable = true;
          };

          sections = lib.mkOption {
            description = "Each section is a file being generated.";
            type = listOf (submodule {
              options = {

                name = lib.mkOption {
                  description = "Name of the lua file.";
                  type = str;
                };

                order = mkOption {
                  description = "The order to import into hyprland.lua.";
                  type = int;
                  default = 99;
                };

                content = lib.mkOption {
                  description = "Contents of a lua file.";
                  type = lines;
                };
              };
            });
          };

          features = {

            hyprmoncfg = {

              enable = mkEnableOption {
                description = "Enable monitor management through hyprmoncfg.";
                default = true;
              };

              package = mkPackageOption pkgs "hyprmoncfg" {
                extraDescription = "Set this to null if you use the Hjem module to install hyprmoncfg.";
                nullable = true;
              };
            };
          };

          plugins = { };
        };

      config = lib.mkIf cfg.enable {

        assertions =
          cfg.sections
          |> map (
            value:
            let
              fileName = "hyprland-${value.name}";
            in
            {
              assertion = lib.validators.validateLua {
                content = value.content;
                inherit fileName;
              };
              message = "windowManagers.hyprland.sections.${value.name} is not valid Lua";
            }
          );

        packages = lib.mkMerge [
          (lib.optional cfg.features.hyprmoncfg.enable cfg.features.hyprmoncfg.package)
        ];

        environment.sessionVariables = {
          MOZ_ENABLE_WAYLAND = "1";
        };

        xdg.config.files = lib.mkMerge [
          {
            "hypr/monitors.lua" = {
              type = "copy";
              clobber = false;
              text = "";
            };

            "hypr/hyprland.lua".text =
              let
                orderedSections = cfg.sections |> builtins.sort (left: right: left.order < right.order);
              in
              # lua
              ''
                ${lib.optionalString cfg.features.hyprmoncfg.enable # lua
                  ''
                    -- hyprmoncfg
                    require("monitors")
                    hl.on("hyprland.start", function ()
                      hl.exec_cmd("${pkgs.hyprmoncfg}/bin/hyprmoncfgd --monitors-conf ${config.xdg.config.directory}/hypr/monitors.lua")
                    end)
                  ''
                }

                -- Files (user defined section files)
                ${lib.concatMapStringsSep "\n" (value: ''require("files/${value.name}")'') orderedSections}
              '';
          }

          (builtins.listToAttrs (
            map (
              value:
              lib.nameValuePair "hypr/files/${value.name}.lua" {
                text = value.content;
              }
            ) cfg.sections
          ))
        ];

      };
    };
}
