{ lib, pkgs, ... }: {
  name = "language";
  order = 1;
  content = # lua
    ''
      hl.config({
          input =  {
              kb_layout = "us,se",
              kb_variant = "",
              kb_options = "grp:alt_shift_toggle"
          }
      })
    '';
}
