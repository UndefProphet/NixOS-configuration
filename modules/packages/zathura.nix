{ lib, ... }: {
  flake.modules.nixos.zathura =
    { config, ... }:
    let
      cfg = config.conf.packages.zathura;
    in
    {
      options.conf.packages.zathura.enable = lib.mkEnableOption {
        description = "Enable zathura";
      };

      config = lib.mkIf cfg.enable {
        hm = { config, ... }: {
          programs.zathura = {
            enable = true;
            extraConfig = ''
              set recolor-reverse-video true # Keeps image colors
              set recolor true # Recolors the content

              set recolor-lightcolor "rgba(0,0,0,0)"
            '';
          };

          # Set zathura as default
          xdg.mimeApps.defaultApplications = lib.mkIf config.programs.zathura.enable {
            # PDF
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];

            # PostScript
            "application/postscript" = [ "org.pwmt.zathura.desktop" ];
            "application/ps" = [ "org.pwmt.zathura.desktop" ];

            # DjVu
            "image/vnd.djvu" = [ "org.pwmt.zathura.desktop" ];
            "image/vnd.djvu+multipage" = [ "org.pwmt.zathura.desktop" ];

            # EPUB
            "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];

            # Comic book formats
            "application/vnd.comicbook+zip" = [ "org.pwmt.zathura.desktop" ]; # cbz
            "application/vnd.comicbook-rar" = [ "org.pwmt.zathura.desktop" ]; # cbr
            "application/x-cbz" = [ "org.pwmt.zathura.desktop" ];
            "application/x-cbr" = [ "org.pwmt.zathura.desktop" ];
            "application/x-cb7" = [ "org.pwmt.zathura.desktop" ];
            "application/x-cbt" = [ "org.pwmt.zathura.desktop" ];

            # XPS / OXPS (mupdf)
            "application/vnd.ms-xpsdocument" = [ "org.pwmt.zathura.desktop" ];
            "application/oxps" = [ "org.pwmt.zathura.desktop" ];
          };
        };
      };
    };
}
