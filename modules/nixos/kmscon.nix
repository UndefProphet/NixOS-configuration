{ lib, ... }: {
  flake.modules.nixos.kmscon =
    { config, username, ... }:
    {
      options.conf.system.kmscon.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.system.kmscon;
        in
        lib.mkIf cfg.enable {
          services.kmscon = {
            enable = true;
            config.hwaccel = true;
          };
        };
    };
}
