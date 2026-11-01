{
  plugins = {
    mini-ai = {
      enable = true;
      settings = {
        n_lines = 50;
        search_method = "cover_or_next";
      };
    };

    mini-diff = {
      enable = true;
      settings = {
        view = {
          style = "sign";
        };
      };
    };

    mini-comment = {
      enable = true;
      settings = {
        mappings = {
          comment = "<leader>/";
          comment_line = "<leader>/";
          comment_visual = "<leader>/";
          textobject = "<leader>/";
        };
      };
    };

    mini-surround = {
      enable = true;
      settings = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
    };
  };
}
