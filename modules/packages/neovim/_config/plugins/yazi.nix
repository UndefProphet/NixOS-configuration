{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.yazi-nvim ];
  extraConfigLua = # lua
    ''
      require('yazi').setup {
        yazi_command = "yazi",
        open_for_directories = true,
        floating_window_scaling_factor = 0.8,
        yazi_floating_window_border = "none"
      }
      vim.keymap.set('n', '<leader>y', function()
        require('yazi').yazi()
      end, { desc = 'File Explorer (Yazi)' })

      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrwPlugin = 1

      -- Yazi
      local path = vim.fn.fnamemodify(vim.fn.argv(0), ":p"):gsub("/$", "")
      vim.env.NVIM_OPENED_PATH = path
    '';
}
