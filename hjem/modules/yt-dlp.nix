{ lib, ... }: {
  flake.modules.hjem-modules.yt-dlp =
    { config, pkgs, ... }:
    let
      cfg = config.programs.yt-dlp;
    in
    {
      options.programs.yt-dlp =
        with lib.types;
        with lib;
        {

          enable = mkEnableOption {
            description = "Enable yt-dlp";
          };

          package = mkPackageOption pkgs "yt-dlp" {
            extraDescription = "Set this to null if you use the Hjem module to install yt-dlp.";
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

        xdg.config.files."yt-dlp/config".text = lib.mkIf (cfg.settings != "") cfg.settings;
      };
    };
}
