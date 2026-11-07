{ lib, ... }: {
  flake.modules.hjem-modules.zathura =
    { config, pkgs, ... }:
    let
      cfg = config.programs.zathura;
    in
    {
      options.programs.zathura =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable zathura";
          };

          package = mkPackageOption pkgs "zathura" {
            extraDescription = "Set this to null if you use the Hjem module to install zathura.";
            nullable = true;
          };

          settings = lib.mkOption {
            description = "Configuration settings.";
            type = lines;
            default = "";
          };

        };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];

        xdg.config.files."zathura/zathurarc".text = lib.mkIf (cfg.settings != "") cfg.settings;
      };
    };
}
