{ lib, ... }: {
  flake.modules.nixos.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.windowManagers.hyprland.sections.globals =
          # lua
          ''
            terminal    = "kitty"
            fileManager = "kitty fish -c \"yazi\""
            menu        = "vicinae toggle"
            browser     = "glide"
          '';

      };
    };
}
