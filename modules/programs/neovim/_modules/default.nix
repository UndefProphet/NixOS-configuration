{ lib, ... }: {
  globals.mapleader = lib.mkDefault " "; # Sets the leader key to comma

  plugins.which-key = {
    enable = true;

    luaConfig.pre = lib.mkDefault ''
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    '';
  };

  plugins.web-devicons.enable = lib.mkDefault true;

  autoCmd = [
    {
      desc = "Change directory to the one provided.";
      event = "VimEnter";
      callback = {
        __raw = # lua
          ''
            function()
              local arg = vim.fn.argv(0)
              if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(arg))
              end
            end
          '';
      };
    }
  ];
}
