{
  inputs,
  lib,
  mkNixosUserSystem,
  ...
}:
{
  flake.nixosConfigurations = {
    desk = mkNixosUserSystem {
      configurationName = "desk";
      system = "x86_64-linux";
      stateVersion = "25.11";
      hostName = "desk";
      username = "tar";

      configuration = {

        collections = {
          core = true;
          terminal = true;
          neural-garbage = true;
          graphical-environment = true;

          packages = {
            generic = true;
            creative.enable = true;
            gaming = true;
            nix-utilities = true;
            wayland-utilities = true;
          };
        };

        conf.networking.wifi.enable = true;
      };

      extraModules = [
        ./_disko.nix
        ./_hardware.nix
      ];
    };
  };
}
