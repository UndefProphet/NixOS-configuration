{ lib, ... }: {
  flake.modules.nixos.ly =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.ly;
    in
    {
      options.conf.environment.ly = {
        enable = lib.mkEnableOption { };
      };

      config = lib.mkIf cfg.enable {
        services.displayManager.ly = {
          enable = true;
        };
      };
    };
}
