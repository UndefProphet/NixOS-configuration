{ lib, ... }: {
  plugins.mini-sessions = {
    enable = true;
    settings = {
      autoread = false;
      autowrite = true;
      file = "Session.vim";
      force = {
        delete = false;
        read = false;
        write = true;
      };
      hooks = {
        post = {
          delete = lib.nixvim.mkRaw "nil";
          read = lib.nixvim.mkRaw "nil";
          write = lib.nixvim.mkRaw "nil";
        };
        pre = {
          delete = lib.nixvim.mkRaw "nil";
          read = lib.nixvim.mkRaw "nil";
          write = lib.nixvim.mkRaw "nil";
        };
      };
      verbose = {
        delete = true;
        read = false;
        write = true;
      };
    };
  };
}
