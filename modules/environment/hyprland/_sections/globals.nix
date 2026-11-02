{ lib, pkgs, ... }: {
  name = "globals";
  order = 0;
  content = # lua
    ''
      terminal    = "kitty"
      fileManager = "kitty fish -c \"yazi\""
      menu        = "vicinae toggle"
      browser     = "glide"
    '';

}
