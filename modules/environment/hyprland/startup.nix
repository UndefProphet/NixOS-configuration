{ lib, ... }: {
  flake.modules.nixos.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.conf.environment.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.windowManagers.hyprland.sections.startup =
          # lua
          ''
            hl.exec_cmd("waypaper --restore --backend awww")
            hl.exec_cmd(terminal)
            hl.exec_cmd("quickshell")
            hl.exec_cmd("awww-daemon")
            hl.exec_cmd("pasytray")
            hl.exec_cmd("qpwgraph --minimized")
            hl.exec_cmd("vicinae server")
            hl.exec_cmd("blueman-applet")
          '';

      };
    };
}
