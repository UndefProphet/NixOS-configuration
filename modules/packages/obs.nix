{ lib, ... }: {
  flake.modules.nixos.obs =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.conf.packages.obs;
    in
    {
      options.conf.packages.obs.enable = lib.mkEnableOption {
        description = "Enable obs";
      };

      config = lib.mkIf cfg.enable {
        programs.obs-studio = {
          enable = true;
          enableVirtualCamera = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-vaapi
            obs-teleport
            wlrobs
            droidcam-obs
          ];
        };

        networking.firewall = {
          # Teleport plugin
          allowedUDPPorts = [ 5678 ];
          allowedTCPPorts = [ 5678 ];
        };
      };
    };
}
