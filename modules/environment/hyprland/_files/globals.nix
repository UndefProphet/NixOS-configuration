{ lib, pkgs, ... }: {
  name = "globals";
  order = 0;
  content = # lua
    ''
      terminal    = "kitty"
      fileManager = "kitty fish -c \"yazi\""
      menu        = "${lib.getExe pkgs.vicinae} toggle"
      browser     = "glide"
    '';

}
