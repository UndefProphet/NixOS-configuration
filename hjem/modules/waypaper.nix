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
      cfg = config.programs.waypaper;
    in
    {
      options.programs.waypaper = {

        enable = lib.mkEnableOption {
          description = "Enable waypaper.";
        };

        package = lib.mkPackageOption pkgs "waypaper" {
          nullable = true;
          extraDescription = "Set this to null if you use the Hjem module to install waypaper.";
        };

        backendPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };

        settings = lib.mkOption {
          type = lib.types.attrs;
          description = "Attrs which will be converted to INI format.";
        };

        settingsEnforce = lib.mkOption {
          default = "copy";
          type = lib.types.enum [
            "copy"
            "symlink"
          ];
          description = "Wheter the settings should be overridable.";
        };

        keybindings = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Attrs which will be converted to INI format.";
        };

        style = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "CSS file for style configuration.";
        };

        overridePrevious = lib.mkEnableOption {
          default = false;
          description = "Override if the settings already exsists.";
        };

      };

      config = lib.mkIf cfg.enable {

        packages = [
          cfg.package
        ]
        ++ cfg.backendPackages;

        xdg.config.files = {
          "waypaper/config.ini" = {
            type = cfg.settingsEnforce;
            clobber = cfg.overridePrevious;
            text = lib.generators.toINI { } {
              Settings = cfg.settings // {
                stylesheet = config.xdg.config.files."waypaper/style.css".target;
                keybindings = config.xdg.config.files."waypaper/keybindings.ini".target;
              };
            };
          };

          "waypaper/keybindings.ini" = {
            text = lib.generators.toINI { } { Settings = cfg.keybindings; };
          };

          "waypaper/style.css" = {
            text = cfg.style;
          };
        };
      };
    };
}
