{ lib, ... }:
{
  flake.modules.nixos.nh =
    { config, ... }:
    let
      cfg = config.conf.terminal.programs.nh;
    in
    {
      options.conf.terminal.programs.nh = {
        enable = lib.mkEnableOption { };

        flake = lib.mkOption {
          description = "Path to the local flake for nh's flake-aware commands.";
          type = lib.types.path;
          default = "/etc/nixos";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.nh = {
          enable = true;
          flake = cfg.flake;
        };
      };
    };
}
