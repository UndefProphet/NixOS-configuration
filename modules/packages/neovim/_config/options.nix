{
  globalOpts = {
    # Line numbers
    number = true;
    relativenumber = true;
    scrolloff = 8;

    # Tabs & Indentation
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;

    # visual
    list = true;
    listchars = {
      tab = "• ";
      trail = "•";
    };

    # Wrapping & UI
    wrap = true;
    linebreak = true;
    cursorline = true;
    termguicolors = true;
    background = "dark";
    signcolumn = "yes";
    cmdheight = 0;
    fillchars = {
      eob = " ";
    };

    # Search settings
    ignorecase = true;
    smartcase = true;

    # Behavior
    backspace = "indent,eol,start";
    clipboard = "unnamedplus";
    splitright = true;
    splitbelow = true;
    swapfile = false;
    confirm = true;

    # Folding
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";

    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    foldcolumn = "auto";
  };
}
