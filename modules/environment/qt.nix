{ lib, ... }: {
  flake.modules.nixos.qt =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.qt;
    in
    {
      options.conf.environment.qt.enable = lib.mkEnableOption { };

      config = lib.mkIf cfg.enable {
        # system qt module installs the style plugins and exposes them in the
        # profiles via QT_PLUGIN_PATH
        qt = {
          enable = true;
          platformTheme = "qt5ct";
          style = "kvantum";
        };

        hj.programs.qt = {
          enable = true;

          platformTheme.name = "qtct";
          style.name = "kvantum";

          qt5ctSettings.Appearance = {
            style = "kvantum";
            icon_theme = config.palette.icons.system.dark;
          };

          qt6ctSettings.Appearance = {
            style = "kvantum";
            icon_theme = config.palette.icons.system.dark;
          };

          kvantum.enable = true;
          kvantum.theme = "Palette";
        };

        hj.packages = with pkgs; [
          kdePackages.dolphin
        ];
      };
    };
}
