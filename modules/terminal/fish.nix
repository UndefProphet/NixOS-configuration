{ lib, ... }: {
  flake.modules.nixos.fish =
    {
      config,
      pkgs,
      username,
      ...
    }:
    let
      cfg = config.conf.terminal.fish;
    in
    {
      options.conf.terminal.fish = {

        enable = lib.mkEnableOption {
          description = "Enable fish shell";
        };

      };

      config = lib.mkIf cfg.enable {

        users.users."${username}".shell = pkgs.fish;
        programs.fish.enable = true;

        hj.programs.fish = {
          enable = true;
          functions.fish_greeting = "";
        };

      };
    };
}
