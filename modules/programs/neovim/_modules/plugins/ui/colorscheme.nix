{ lib, ... }: {
  # {self, lib, ...}:{

  # colorschemes.base16 = {
  #   enable = true;
  # colorscheme = with self.nixosConfiguration.desktop.config.lib.stylix.colors.withHashtag; {
  #   inherit base00;
  #   inherit base01;
  #   inherit base02;
  #   inherit base03;
  #   inherit base04;
  #   inherit base05;
  #   inherit base06;
  #   inherit base07;
  #   inherit base08;
  #   inherit base09;
  #   inherit base0A;
  #   inherit base0B;
  #   inherit base0C;
  #   inherit base0D;
  #   inherit base0E;
  #   inherit base0F;
  # };
  # };

  colorschemes = {

    everforest = {
      enable = false;
      settings = {
        terminal_colors = lib.mkDefault true; # add neovim terminal colors
        undercurl = lib.mkDefault true;
        underline = lib.mkDefault true;
        bold = lib.mkDefault true;
        italic = {
          strings = lib.mkDefault true;
          emphasis = lib.mkDefault true;
          comments = lib.mkDefault true;
          operators = lib.mkDefault false;
          folds = lib.mkDefault true;
        };
        strikethrough = lib.mkDefault true;
        invert_selection = lib.mkDefault false;
        invert_signs = lib.mkDefault false;
        invert_tabline = lib.mkDefault false;
        inverse = lib.mkDefault true; # invert background for search, diffs, statuslines and errors
        contrast = lib.mkDefault ""; # can be "hard", "soft" or empty string
        palette_overrides = { };
        overrides = { };
        dim_inactive = lib.mkDefault false;
        transparent_background = 1;
      };
    };

    gruvbox = {
      enable = lib.mkDefault true;
      settings = {
        terminal_colors = lib.mkDefault true; # add neovim terminal colors
        undercurl = lib.mkDefault true;
        underline = lib.mkDefault true;
        bold = lib.mkDefault true;
        italic = {
          strings = lib.mkDefault true;
          emphasis = lib.mkDefault true;
          comments = lib.mkDefault true;
          operators = lib.mkDefault false;
          folds = lib.mkDefault true;
        };
        strikethrough = lib.mkDefault true;
        invert_selection = lib.mkDefault false;
        invert_signs = lib.mkDefault false;
        invert_tabline = lib.mkDefault false;
        inverse = lib.mkDefault true; # invert background for search, diffs, statuslines and errors
        contrast = lib.mkDefault "hard"; # can be "hard", "soft" or empty string
        palette_overrides = { };
        overrides = { };
        dim_inactive = lib.mkDefault false;
        transparent_mode = lib.mkDefault true;
      };
    };
  };
}
