{ lib, ... }: {
  flake.modules.hjem-modules.qt =
    { config, pkgs, ... }:
    let
      cfg = config.programs.qt;

      iniFormat = pkgs.formats.ini {
        listToValue = lib.concatStringsSep ", ";
      };

      # maps option names to their QT_QPA_PLATFORMTHEME counterpart when needed
      platformThemeNames = {
        qtct = "qt5ct";
        gtk = "gtk3";
      };

      platformPackages = with pkgs; {
        qtct = [
          libsForQt5.qt5ct
          qt6Packages.qt6ct
        ];
      };

      stylePackages = with pkgs; {
        kvantum = [
          libsForQt5.qtstyleplugin-kvantum
          qt6Packages.qtstyleplugin-kvantum
        ];
      };

      platformThemePackages =
        if cfg.platformTheme.package != null
        then lib.toList cfg.platformTheme.package
        else lib.optionals (cfg.platformTheme.name != null) (platformPackages.${cfg.platformTheme.name} or [ ]);

      chosenStylePackages =
        if cfg.style.package != null
        then lib.toList cfg.style.package
        else lib.optionals (cfg.style.name != null) (stylePackages.${lib.toLower cfg.style.name} or [ ]);

      kvantumValue =
        let
          general = cfg.kvantum.settings.General or { };
        in
        cfg.kvantum.settings
        // (lib.optionalAttrs (cfg.kvantum.enable && cfg.kvantum.theme != null) {
          General = general // { theme = cfg.kvantum.theme; };
        });

      themeFile =
        let
          theme = cfg.kvantum.theme;
        in
        if theme != null
        then "Kvantum/${theme}/${theme}.kvconfig"
        else null;

      qtctConf =
        [ "qt5ct" "qt6ct" ]
        |> lib.filter (name: cfg."${name}Settings" != null)
        |> map (name: lib.nameValuePair "${name}/${name}.conf" {
          generator = x: iniFormat.generate "${name}-config" x;
          value = cfg."${name}Settings";
        })
        |> builtins.listToAttrs;

      configFiles =
        (lib.optionalAttrs (themeFile != null && cfg.kvantum.themeConfig != "") {
          ${themeFile}.text = cfg.kvantum.themeConfig;
        })
        // (lib.optionalAttrs (kvantumValue != { }) {
          "Kvantum/kvantum.kvconfig" = {
            generator = iniFormat.generate "kvantum-config";
            value = kvantumValue;
          };
        })
        // qtctConf;
    in
    {
      options.programs.qt = {
        enable = lib.mkEnableOption { };

        platformTheme = {
          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "qtct";
            description = "Platform theme plugin, deriving QT_QPA_PLATFORMTHEME.";
          };

          package = lib.mkOption {
            type = lib.types.nullOr (lib.types.either lib.types.package (lib.types.listOf lib.types.package));
            default = null;
            description = "Platform theme package overriding the auto-detected one.";
          };
        };

        style = {
          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "kvantum";
            description = "Widget style, deriving QT_STYLE_OVERRIDE.";
          };

          package = lib.mkOption {
            type = lib.types.nullOr (lib.types.either lib.types.package (lib.types.listOf lib.types.package));
            default = null;
            description = "Style package overriding the auto-detected one.";
          };
        };

        qt5ctSettings = lib.mkOption {
          type = lib.types.nullOr iniFormat.type;
          default = null;
          example = {
            Appearance.style = "kvantum";
          };
          description = ''
            qt5ct configuration written to qt5ct/qt5ct.conf.
            Lists are translated to comma-separated strings, fonts must be quoted.
          '';
        };

        qt6ctSettings = lib.mkOption {
          type = lib.types.nullOr iniFormat.type;
          default = null;
          example = {
            Appearance.style = "kvantum";
          };
          description = ''
            qt6ct configuration written to qt6ct/qt6ct.conf.
            Lists are translated to comma-separated strings, fonts must be quoted.
          '';
        };

        kvantum = {
          enable = lib.mkEnableOption { };

          theme = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "KvAdapta";
            description = ''
              Selected Kvantum theme, written as General.theme to
              Kvantum/kvantum.kvconfig.
            '';
          };

          themeConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = ''
              Contents of the custom Kvantum theme at
              Kvantum/theme/theme.kvconfig (theme = programs.qt.kvantum.theme).
            '';
          };

          settings = lib.mkOption {
            type =
              lib.types.submodule {
                freeformType = lib.types.attrsOf (lib.types.attrsOf iniFormat.lib.types.atom);
              };
            default = { };
            description = "Global configuration written to Kvantum/kvantum.kvconfig.";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        packages = platformThemePackages ++ chosenStylePackages;

        environment.sessionVariables =
          (lib.optionalAttrs (cfg.platformTheme.name != null) {
            QT_QPA_PLATFORMTHEME = platformThemeNames.${cfg.platformTheme.name} or cfg.platformTheme.name;
          })
          // (lib.optionalAttrs (cfg.style.name != null) {
            QT_STYLE_OVERRIDE = cfg.style.name;
          });

        xdg.config.files = configFiles;
      };
    };
}
