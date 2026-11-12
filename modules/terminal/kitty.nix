{ lib, ... }: {
  flake.modules.nixos.kitty =
    {
      config,
      pkgs,
      username,
      ...
    }:
    let
      cfg = config.conf.terminal.kitty;
    in
    {
      options.conf.terminal.kitty = {

        enable = lib.mkEnableOption {
          description = "Enable fish shell";
        };

      };

      config = lib.mkIf cfg.enable {
        hj.programs.kitty = {
          enable = true;
          settings = {
            confirm_os_window_close = 0;

            "map ctrl+shift+enter" = "launch --cwd=current --type=os-window";
          };
        };
      };
    };
}
