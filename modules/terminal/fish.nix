{ lib, ... }: {
  flake.modules.nixos.fish =
    {
      config,
      pkgs,
      username,
      ...
    }:
    let
      cfg = config.terminal.fish;
    in
    {
      options.conf.terminal.fish = {

        enable = lib.mkEnableOption {
          description = "Enable fish shell";
        };

      };

      config = {

        users.users."${username}".shell = pkgs.fish;
        programs.fish.enable = true;

        # hj = {
        #   programs.fish = {
        #     enable = config.programs.fish.enable;
        #     # shellInit = ''
        #     # tmux
        #     # '';
        #     functions = {
        #       fish_greeting = "";
        #     };
        #   };
        # };
      };
    };
}
