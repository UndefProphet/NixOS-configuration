# TODO REMOVE Stylix and manage colorscheme manually
{ inputs, ... }: {
  # https://github.com/nix-community/stylix
  # Stylix is a theming framework for NixOS, Home Manager, nix-darwin, and Nix-on-Droid.
  tack.inputs.stylix = "gh:nix-community/stylix?ref=master";

  flake.modules.nixos.stylix =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        # enable = true;
        autoEnable = true;
        polarity = "dark";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/black-metal-bathory.yaml";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/black-metal-khold.yaml";

        base16Scheme = {
          base00 = "#000000"; # ----
          base01 = "#3c3836"; # ---
          base02 = "#504945"; # --
          base03 = "#665c54"; # -
          base04 = "#bdae93"; # +
          base05 = "#d5c4a1"; # ++
          base06 = "#ebdbb2"; # +++
          base07 = "#fbf1c7"; # ++++
          base08 = "#fb4934"; # red
          base09 = "#fe8019"; # orange
          base0A = "#fabd2f"; # yellow
          base0B = "#b8bb26"; # green
          base0C = "#8ec07c"; # aqua/cyan
          base0D = "#83a598"; # blue
          base0E = "#d3869b"; # purple
          base0F = "#d65d0e"; # brown
        };

        opacity =
          let
            opacity = 0.85;
          in
          {
            applications = opacity;
            desktop = opacity;
            terminal = opacity;
            popups = opacity;
          };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light"; # Dark mode seems to not be used sometimes.
        };

        # cursor = {
        #   package = handofevil;
        #   name = "hand-of-evil";
        #   size = 24;
        # };

        fonts = {
          sizes =
            let
              size = 10.0;
            in
            {
              terminal = 9.0;
              # terminal     = size;
              applications = size;
              desktop = size;
              popups = size;
            };

          # sansSerif = {
          #   name = "Libron";
          #   package = pkgs.callPackage ./_libron.nix {};
          # };
          #
          # serif = {
          #   name = "Libron";
          #   package = pkgs.callPackage ./_libron.nix {};
          # };
          #
          # monospace = {
          #   name = "Libron";
          #   package = pkgs.callPackage ./_libron.nix {};
          # };

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

        targets = {
          # hyprland.enable = false;

          console.enable = true;
          spicetify.enable = false;
          nixvim.enable = false;
          kmscon.enable = false;

          fish.enable = false;
        };
      };

      # hm.stylix.targets = {
      #   firefox = {
      #     profileNames = [
      #       "default"
      #       "streaming"
      #     ];
      #     colorTheme.enable = true;
      #   };
      #
      #   zen-browser = {
      #     profileNames = [ "default" ];
      #   };
      #
      #   # yazi.enable = false;
      # };
    };
}
