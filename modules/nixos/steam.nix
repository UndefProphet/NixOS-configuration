{ lib, ... }: {
  flake.modules.nixos.steam =
    { config, ... }:
    let
      cfg = config.conf.gaming.steam;
    in
    {

      options.conf.gaming.steam.enable = lib.mkEnableOption {
        description = "Enable steam";
      };

      config = lib.mkIf cfg.enable {
        programs.steam = {
          enable = true;
          protontricks.enable = true;
        };
      };
    };
}
