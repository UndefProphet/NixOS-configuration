{ lib, ... }: {
  flake.modules.nixos.zathura =
    {
      config,
      ...
    }:
    let
      cfg = config.conf.programs.zathura;
    in
    {
      options.conf.programs.zathura = {

        enable = lib.mkEnableOption {
          description = "Enable zathura";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.zathura = {
          enable = true;

          settings = ''

          '';
        };

      };
    };
}
