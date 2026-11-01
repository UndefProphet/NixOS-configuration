{ pkgs, ... }: {
  plugins.treesitter = {
    enable = true;
    highlight = {
      enable = true;
      disable = [
        "markdown"
      ];
    };
    settings = {
      indent.enable = true;
      folding.enable = true;
      autopairs.enable = true;
      incremental_selection.enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      auto_install = false;
      ensureInstalled = [
        "nix"
        "qmljs"
      ];
    };
  };

  plugins.treesitter-context = {
    enable = true;
  };
}
