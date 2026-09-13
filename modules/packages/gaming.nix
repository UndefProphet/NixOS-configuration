{ lib, ... }: {
  flake.modules.nixos.gaming =
    { config, ... }:
    let
      cfg = config.conf.packages.gaming;
    in
    {
      options.conf.packages.gaming.enable = lib.mkEnableOption {
        description = "Enable gaming";
      };

      config = lib.mkIf cfg.enable {
        programs.steam = {
          enable = true;
          protontricks.enable = true;
        };
      };
    };
}
