{ lib, ... }:
{
  flake.modules.hjem-modules.direnv =
    { config, pkgs, ... }:
    let
      cfg = config.programs.direnv;
    in
    {
      options.programs.direnv = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "direnv" { };

        settings = lib.mkOption {
          description = "Configuration settings for direnv.toml.";
          type = lib.types.lines;
          default = "";
        };
      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];

        programs.fish.interactiveShellInit = ''
          if not functions -q __direnv_export_eval
            ${lib.getExe cfg.package} hook fish | source
          end
        '';

        xdg.config.files = lib.mkIf (cfg.settings != "") {
          "direnv/direnv.toml".text = cfg.settings;
        };
      };
    };
}
