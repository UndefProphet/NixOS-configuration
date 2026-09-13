{ lib, ... }: {
  flake.modules.nixos.auto-mount-usb =
    { config, username, ... }:
    let
      cfg = config.conf.packages.firefox;
    in
    {

      options.conf.system.auto-mount-disk.enable = lib.mkEnableOption {
        description = "Enable auto mounting disks";
      };

      config = lib.mkIf cfg.enable {
        services.gvfs.enable = true;

        hm = {
          services.udiskie = {
            enable = true;
            automount = true;
            tray = "auto";
            notify = true;
            settings = {
              program_options = {
                file_manager = "xdg-open";
              };
            };
          };

          systemd.user.tmpfiles.rules = [
            "L+ /home/${username}/disks - - - - /run/media/${username}"
          ];
        };
      };
    };
}
