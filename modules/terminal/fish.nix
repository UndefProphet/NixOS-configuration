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

          shellAliases = {
            g = "git";
            l = "ls -la";
          };

          shellAbbrs = {
            gco = "git checkout";
            gs = "git status";
            gp = "git pull";
            gca = {
              position = "anywhere";
              expansion = "git commit -am";
            };
          };

          functions = { };
          binds = { };
          plugins = [ ];
        };

      };
    };
}
