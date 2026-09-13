{ lib, ... }: {
  flake.modules.nixos.docker =
    { config, username, ... }:
    let
      cfg = config.conf.system.docker;
    in
    {
      options.conf.system.docker = {

        enable = lib.mkEnableOption {
          default = false;
          description = "Enable grub bootloader";
        };

      };

      config = lib.mkIf cfg.enable {

      users.users.${username}.extraGroups = [ "docker" ];
      virtualisation = {
        docker.enable = true;
      };

      };

    };
}
