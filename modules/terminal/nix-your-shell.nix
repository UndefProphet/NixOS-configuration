{ lib, ... }: {
  flake.modules.nixos.nix-your-shell =
    {
      config,
      ...
    }:
    let
      cfg = config.conf.terminal.programs.nix-your-shell;
    in
    {
      options.conf.terminal.programs.nix-your-shell = {

        enable = lib.mkEnableOption {
          description = "Enable nix-your-shell";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.nix-your-shell = {
          enable = true;

          nix-output-monitor.enable = true;
        };

      };
    };
}
