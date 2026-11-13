{ ... }:
{
  flake.nixosConfigurations.lap = {
    configurationName = "lap";
    system = "x86_64-linux";
    stateVersion = "25.11";
    hostName = "lap";
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
}
