{ inputs, ... }: {
  # https://github.com/nix-community/home-manager
  # Provides a module system for managing a user environment.
  # tack.inputs.base16 = "gh:SenchoPens/base16.nix?ref=main";
  tack.inputs.palette-nix = "gh:undefprophet/palette.nix?ref=main";

  flake.modules.nixos.palette =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.palette-nix.nixosModules.default
      ];

      palette = with config.lib.palette; {
        enable = true;
        _startIncrementFromOneGetBase = false;
        colorscheme = ./colorschemes/gruvbox.yml;
        opacity = 0.90;

        icons = {
          system = {
            name = "Papirus Icon Theme";
            package = pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
            light = "Papirus-Light"; # Dark mode seems to not be used sometimes.
          };
        };

        cursors = {
          system = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
          };
        };

        fonts = {
          sizes =
            let
              size = 10.0;
            in
            {
              terminal = 9.0;
              applications = size;
              desktop = size;
              popups = size;
            };

          sansSerif = {
            name = "JetBrainsMonoNL Nerd Font Mono";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };

          serif = {
            name = "JetBrainsMonoNL Nerd Font Mono";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };

          monospace = {
            name = "JetBrainsMonoNL Nerd Font Mono";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
        };

        colors = {

          mnemonic = {
            background = getBase 0;
            lighter-background = getBase 1;
            selection-background = getBase 2;
            comments = getBase 3;
            dark-foreground = getBase 4;
            foreground = getBase 5;
            light-foreground = getBase 6;
            lightest-foreground = getBase 7;
            red = getBase 8;
            orange = getBase 9;
            yellow = getBase 10;
            green = getBase 11;
            cyan = getBase 12;
            blue = getBase 13;
            purple = getBase 14;
            brown = getBase 15;

            # Base24 extension (base10 - base17)
            darker-background = getBase 16;
            darkest-background = getBase 17;
            bright-red = getBase 18;
            bright-orange = getBase 19;
            bright-yellow = getBase 20;
            bright-green = getBase 21;
            bright-cyan = getBase 22;
            bright-blue = getBase 23;
          };

          ui = {
            qt = {
              window = getBase 0;
              base = getBase 0;
              altBase = getBase 1;
              button = getBase 1;
              text = getBase 5;
              brightText = getBase 6;
              windowText = getBase 5;
              buttonText = getBase 5;
              highlight = getBase 13;
              highlightText = getBase 0;
              link = getBase 13;
              visitedLink = getBase 14;
              toolTipBase = getBase 1;
              toolTipText = getBase 5;
              light = getBase 6;
              midlight = getBase 5;
              dark = getBase 0;
              mid = getBase 0;
              shadow = getBase 0;
              red = getBase 8;
            };
          };

          terminal = {
            background = getBase 0;
            lighter-background = getBase 1;
            selection-background = getBase 2;
            comments = getBase 3;
            dark-foreground = getBase 4;
            foreground = getBase 5;
            light-foreground = getBase 6;
            lightest-foreground = getBase 7;
            red = getBase 8;
            orange = getBase 9;
            yellow = getBase 10;
            green = getBase 11;
            cyan = getBase 12;
            blue = getBase 13;
            purple = getBase 14;
            brown = getBase 15;

            # Base24 extension (base10 - base17)
            darker-background = getBase 16;
            darkest-background = getBase 17;
            bright-red = getBase 18;
            bright-orange = getBase 19;
            bright-yellow = getBase 20;
            bright-green = getBase 21;
            bright-cyan = getBase 22;
            bright-blue = getBase 23;

            # Additional
            suggestion = getBase 3; # |> tint 0.55;
          };

        };

      };
    };
}
