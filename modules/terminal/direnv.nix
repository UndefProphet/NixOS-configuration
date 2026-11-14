{ lib, ... }: {
  flake.modules.nixos.direnv =
    {
      config,
      ...
    }:
    let
      cfg = config.conf.terminal.programs.direnv;
    in
    {
      options.conf.terminal.programs.direnv = {

        enable = lib.mkEnableOption {
          description = "Enable direnv";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.direnv = {
          enable = true;
        };

      };
    };
}
