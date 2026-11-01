{
  plugins.bufferline = {
    enable = true;

    settings = {
      options = {
        close_command = {
          __raw = "function(n) Snacks.bufdelete(n) end";
        };
        right_mouse_command = {
          __raw = "function(n) Snacks.bufdelete(n) end";
        };
        diagnostics = "nvim_lsp";
        always_show_bufferline = true;
        # diagnostics_indicator = { __raw =''
        #   function(_, _, diag)
        #     local icons = LazyVim.config.icons.diagnostics
        #     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        #       .. (diag.warning and icons.Warn .. diag.warning or "")
        #     return vim.trim(ret)
        #   end,
        # ''; };

        offsets = [
          {
            filetype = "neo-tree";
            text = "Tree";
            highlight = "Directory";
            text_align = "left";
          }
          {
            filetype = "snacks_layout_box";
          }
        ];
      };
    };
  };
}
