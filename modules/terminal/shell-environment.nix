{ lib, ... }: {
  flake.modules.nixos.shell-environment = { config, pkgs, ... }: {

    options.conf.terminal.shell-environment.enable = lib.mkEnableOption { };

    config =
      let
        cfg = config.conf.terminal.shell-environment;
      in
      lib.mkIf cfg.enable {

        console.colors = with config.palette.colors.hex.mnemonic; [
          background.withoutHash
          red.withoutHash
          green.withoutHash
          yellow.withoutHash
          blue.withoutHash
          purple.withoutHash
          cyan.withoutHash
          foreground.withoutHash
          comments.withoutHash
          bright-red.withoutHash
          bright-green.withoutHash
          bright-yellow.withoutHash
          bright-blue.withoutHash
          purple.withoutHash
          bright-cyan.withoutHash
          lightest-foreground.withoutHash
        ];

        hm = {

          programs = {
            direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            nh.enable = true;
            zoxide.enable = true;
            lsd.enable = true;
            starship = {
              enable = true;
              enableTransience = true;
            };

            btop.enable = true;
            eza = {
              # package = pkgs.eza.overrideAttrs (o: {
              #   patches = (o.patches or [ ]) ++ [ ./_eza/custom-icons.patch ];
              #   doCheck = false;
              # });
              enable = true;
            };
          };

          home.packages = with pkgs; [
            isd
            trash-cli
          ];

          home.shellAliases = {
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
            cd = "z"; # Zoxide alias
          };
        };
      };

  };
}
