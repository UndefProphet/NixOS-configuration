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

            # Vim to NVim
            v = "nvim";
            vi = "nvim";
            vim = "nvim";

            y = "yazi";

            # Utilities
            disks = lib.getExe pkgs.disktui;
            audio = lib.getExe pkgs.wiremix;
            music = lib.getExe pkgs.cliamp;
            wifi = lib.getExe pkgs.impala;
            bluetooth = lib.getExe pkgs.bluetui;

            rm = "${pkgs.trash-cli}/bin/trash";

            # Improvements
            # ls = "lsd -lhFXN";
            open = "xdg-open";
            cat = "${pkgs.bat}/bin/bat";
            # cd = "z"; # Zoxide alias
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
