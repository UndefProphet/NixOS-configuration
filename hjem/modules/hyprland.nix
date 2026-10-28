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
            type = types.attrsOf (
              types.submodule {
                options = {
                  order = mkOption {
                    description = "The order to import into hyprland.lua.";
                    type = int;
                    default = 99;
                  };

                  content = lib.mkOption {
                    description = "Contents of a lua file.";
                    type = str;
                  };
                };
              }
            );
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
          |> lib.mapAttrsToList (
            name: value: {
              assertion = lib.validators.validateLua {
                content = value.content;
                fileName = "hyprland-${name}";
              };
              message = "windowManagers.hyprland.sections.${name} is not valid Lua";
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
                files = cfg.sections |> lib.mapAttrsToList (name: value: value // { inherit name; });
                orderedFiles = files |> builtins.sort (left: right: left.order < right.order);
              in
              # lua
              ''
                -- Features
                ${lib.optionalString cfg.features.hyprmoncfg.enable ''require("monitors") -- hyprmoncfg ''}

                -- Files (user defined section files)
                ${lib.concatMapStringsSep "\n" (value: ''require("files.${value.name}")'') orderedFiles}
              '';
          }

          # Generate the user defined section files
          (
            cfg.sections
            |> lib.mapAttrs' (name: value: lib.nameValuePair "hypr/files/${name}.lua" { text = value.content; })
          )
        ];

      };
    };
}
