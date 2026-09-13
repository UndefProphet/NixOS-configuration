{
  inputs,
  lib,
  mkNixosUserSystem,
  ...
}:
{
  flake.nixosConfigurations = {
    lap = mkNixosUserSystem {
      configurationName = "lap";
      system = "x86_64-linux";
      stateVersion = "25.11";
      hostName = "lap";
      username = "tar";

      configuration = {

        collections = {
          core = true;
          terminal = true;
          graphical-environment = true;

          packages = {
            generic.enable = true;
            creative.enable = true;
            gaming.enable = true;
            nix-utilities.enable = true;
            wayland-utilities.enable = true;
          };
        };

        conf.networking.wifi.enable = true;
        conf.packages.ddcutil.enable = true;
        conf.system.auto-mount-disk.enable = true;

        services.fwupd.enable = true;

        conf.system.docker.enable = true;
      };

      extraModules = [
        ./_disko.nix
        ./_hardware.nix
      ];
    };
  };
}
