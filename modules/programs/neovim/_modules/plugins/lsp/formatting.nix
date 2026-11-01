{

  #   globalOpts = {
  # formatexpr = "v:lua.require'conform'.formatexpr()";
  #   };

  plugins.conform-nvim = {
    enable = true;

    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
      };
    };
  };
}
