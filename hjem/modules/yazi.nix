{ lib, ... }: {
  flake.modules.hjem-modules.yazi =
    { config, pkgs, ... }:
    let
      cfg = config.programs.yazi;
      tomlFormat = pkgs.formats.toml { };
    in
    {
      options.programs.yazi =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable yazi";
          };

          package = mkPackageOption pkgs "yazi" {
            extraDescription = "Set this to null if you use the Hjem module to install yazi.";
            nullable = true;
          };

          extraPackages = mkOption {
            type = listOf package;
            default = [ ];
            example = literalExpression "[ pkgs.tree ]";
            description = "Extra packages available to OpenCode.";
          };

          settings = {
            yazi = lib.mkOption {
              description = "Configuration settings.";
              inherit (tomlFormat) type;
              default = { };
            };

            theme = lib.mkOption {
              description = "Configuration theme.";
              inherit (tomlFormat) type;
              default = { };
            };

            keymap = lib.mkOption {
              description = "Configuration keymap.";
              inherit (tomlFormat) type;
              default = { };
            };
          };

        };

      config = lib.mkIf cfg.enable {

        packages =
          let
            packageWithExtraPackages =
              if cfg.package != null && cfg.extraPackages != [ ] then
                pkgs.symlinkJoin {
                  inherit (cfg.package) meta;
                  name = "${lib.getName cfg.package}-wrapped-${lib.getVersion cfg.package}";
                  paths = [ cfg.package ];
                  preferLocalBuild = true;
                  nativeBuildInputs = [ pkgs.makeWrapper ];
                  postBuild = ''
                    wrapProgram $out/bin/${cfg.package.meta.mainProgram} \
                      --suffix PATH : ${lib.makeBinPath cfg.extraPackages}
                  '';
                }
              else
                cfg.package;
          in
          [ packageWithExtraPackages ];

        xdg.config.files =
          cfg.settings
          |> lib.mapAttrs' (
            name: value:
            lib.nameValuePair "yazi/${name}" {
              inherit value;
              generator = tomlFormat.generate "yazi-${name}";
            }
          );

      };
    };
}
