{ lib, ... }: {
  flake.modules.nixos.ddcutil =
    {
      config,
      username,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.packages.ddcutil;
    in
    {
      options.conf.packages.ddcutil.enable = lib.mkEnableOption {
        description = "Enable ddcutil";
      };

      config = lib.mkIf cfg.enable {
        hardware.i2c.enable = true;
        users.users."${username}" = {
          packages = with pkgs; [ ddcutil ];
          extraGroups = [ "i2c" ];
        };

        # boot.kernelParams = [ "amdgpu.dcfeaturemask=2" ];
      };
    };
}
