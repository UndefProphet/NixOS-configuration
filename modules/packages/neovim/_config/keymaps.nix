{
  keymaps = [
    # --- Normal Mode: Move Lines ---
    {
      mode = "n";
      key = "<A-j>";
      action = ":m .+1<CR>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = ":m .-2<CR>==";
      options.desc = "Move line up";
    }

    # --- Visual Mode: Move Selection ---
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }

    # --- Window Management ---
    {
      mode = "n";
      key = "<leader>sv";
      action = "<C-w>v";
      options.desc = "Split window vertically";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<C-w>s";
      options.desc = "Split window horizontally";
    }
    {
      mode = "n";
      key = "<leader>sx";
      action = "<cmd>close<CR>";
      options.desc = "Close current split";
    }
    {
      mode = "n";
      key = "<leader>se";
      action = "<C-w>=";
      options.desc = "Make splits equal size";
    }

    # --- Tab Management ---
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>tabnew<CR>";
      options.desc = "Open new tab";
    }
    {
      mode = "n";
      key = "<leader>tx";
      action = "<cmd>tabclose<CR>";
      options.desc = "Close current tab";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>tabn<CR>";
      options.desc = "Go to next tab";
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = "<cmd>tabp<CR>";
      options.desc = "Go to previous tab";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>tabnew %<CR>";
      options.desc = "Buffer to new tab";
    }

    # --- Commenting Lines ---
    {
      mode = [
        "n"
        "v"
      ];
      key = "<C-/>";
      action = "gcc";
      options = {
        remap = true;
        desc = "Comment";
      };
    }
    {
      mode = "i";
      key = "<C-/>";
      action = "<C-o>gcc";
      options = {
        remap = true;
        desc = "Comment";
      };
    }
  ];
  # vim.api.nvim_create_autocmd("FileType", {
  #   pattern = { "html", "tex" },
  #   callback = function()
  #     vim.keymap.set("n", "j", "gj", { buffer = true })
  #     vim.keymap.set("n", "k", "gk", { buffer = true })
  #   end,
  # })
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [
        "html"
        "tex"
      ];
      callback = {
        __raw = # lua
          ''
            function()
              vim.keymap.set("n", "j", "gj", { buffer = true })
              vim.keymap.set("n", "k", "gk", { buffer = true })
            end
          '';
      };
    }
  ];
}
