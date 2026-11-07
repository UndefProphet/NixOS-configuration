{ inputs, ... }: {
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

        };

      };
    };
}
