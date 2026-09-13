{ lib, ... }: {
  flake.modules.nixos.ddccontrol =
    { config, username, ... }:
    {
      options.conf.system.ddccontrol.enable = lib.mkEnableOption {
        description = "Enable ddccontrol";
      };

      config =
        let
          cfg = config.conf.system.ddccontrol;
        in
        lib.mkIf cfg.enable {
          services.ddccontrol.enable = true;
          users.users.${username}.extraGroups = [ config.hardware.i2c.group ];
        };
    };
}
