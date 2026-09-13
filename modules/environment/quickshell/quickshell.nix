{ lib, ... }: {

  flake.modules.nixos.audio = { config, pkgs, ... }: {

    options.conf.environment.quickshell.enable = lib.mkEnableOption { };

    config =
      let
        cfg = config.conf.environment.quickshell;
      in
      lib.mkIf cfg.enable {

        hm.programs.quickshell = {
          enable = true;
          configs = {
            "default" = ./default;
          };
          activeConfig = "default";
        };

      };
  };
}
