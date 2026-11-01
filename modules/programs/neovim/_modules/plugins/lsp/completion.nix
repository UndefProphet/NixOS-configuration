{
  # TODO FIX blink showing up behind or infornt of cmp also add sources to blink
  # plugins.blink-cmp  = {
  #   enable = true;
  #   settings = {
  #     keymap = { preset = "default"; };
  #     appearance = {
  #       use_nvim_cmp_as_default = true;
  #       nerd_font_variant = "mono";
  #     };
  #     signature = { enabled = true; };
  #   };
  # };
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      mapping = {
        __raw = ''
          cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          })'';
      };

      snippet.expand = {
        __raw = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };

      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "nvim_lsp_signature_help"; }
      ];
    };
  };

  plugins.cmp-nvim-lsp-signature-help = {
    enable = true;
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-nvim-lua.enable = true;
  plugins.cmp_luasnip.enable = true;
  plugins.cmp-treesitter.enable = true;
}
