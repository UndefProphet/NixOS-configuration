{ lib, ... }: {

  tack.inputs = {
    hyprland = "gh:hyprwm/Hyprland?ref=main";
    # hyprland = "gh:yayuuu/hyprland-scroll-overview?ref=main";
  };

  flake.modules.nixos.hyprland =
    {
      inputs',
      config,
      pkgs,
      username,
      ...
    }:
    {
      options.conf.environment.hyprland.enable = lib.mkEnableOption { };

      config =
        let
          cfg = config.conf.environment.hyprland;
        in
        lib.mkIf cfg.enable {

          # imports = [
          #   ./_filechooser/yazi.nix
          #   ./_wallpaper-manager/waypaper.nix
          # ];

          conf.environment.wallpaper.waypaper.enable = true;
          conf.environment.quickshell.enable = true;

          programs.hyprland = {
            enable = true;
            xwayland.enable = true;
            # portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
            # package = inputs'.hyprland.packages.hyprland;
            withUWSM = true;
          };

          users.users."${username}".packages = with pkgs; [
            kanshi
          ];

          hm = {
            programs.vicinae.enable = true;
            services.dunst = {
              enable = true;
              settings = {
                global = {
                  # origin = "top-center";
                  offset = "(380, 30)";
                };
              };
            };
            services.hyprpolkitagent.enable = true;

            wayland.windowManager.hyprland = {
              enable = config.programs.hyprland.enable;
              # package = config.programs.hyprland.package;
              # portalPackage = config.programs.hyprland.portalPackage;
              configType = "lua";

              plugins = with pkgs.hyprlandPlugins; [
                # inputs'.hyprland-scroll-overview.packages.scrolloverview
              ];

              xdph.settings.screencopy = {
                allow_token_by_default = true;
                max_fps = 60;
              };
            };
          };
        };
    };
}
