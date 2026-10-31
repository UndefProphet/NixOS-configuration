{ lib, ... }: {
  flake.modules.hjem-modules.opencode =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.programs.opencode;
    in
    {
      options.programs.opencode =
        let
          jsonFormat = pkgs.formats.json { };
        in
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable Opencode";
          };

          package = mkPackageOption pkgs "opencode" {
            extraDescription = "Set this to null if you use the Hjem module to install opencode.";
            nullable = true;
          };

          extraPackages = mkOption {
            type = listOf package;
            default = [ ];
            example = literalExpression "[ pkgs.nodejs ]";
            description = "Extra packages available to OpenCode.";
          };

          settings = mkOption {
            inherit (jsonFormat) type;
            default = { };
            example = {
              autoshare = false;
              autoupdate = false;
            };
            description = ''
              Configuration written to {file}`$XDG_CONFIG_HOME/opencode/opencode.json`.
              See <https://opencode.ai/docs/config/> for the documentation.
            '';
          };

          tui = mkOption {
            inherit (jsonFormat) type;
            default = { };
            example = {
              theme = "system";
            };
            description = ''
              Configuration written to {file}`$XDG_CONFIG_HOME/opencode/tui.json`.
              See <https://opencode.ai/docs/tui/> for the documentation.
            '';
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

        xdg.config.files."opencode/opencode.json".text = lib.pretty.jsonText (
          builtins.toJSON ({ "$schema" = "https://opencode.ai/config.json"; } // cfg.settings)
        );

        xdg.config.files."opencode/tui.json".text = lib.pretty.jsonText (
          builtins.toJSON ({ "$schema" = "https://opencode.ai/tui.json"; } // cfg.tui)
        );
      };
    };
}
