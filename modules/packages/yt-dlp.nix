{ lib, ... }: {
  flake.modules.nixos.yt-dlp =
    { config, ... }:
    let
      cfg = config.conf.packages.yt-dlp;
    in
    {
      options.conf.packages.yt-dlp.enable = lib.mkEnableOption {
        description = "Enable yt-dlp";
      };

      config = lib.mkIf cfg.enable {
        hm.programs.yt-dlp = {
          enable = true;
          settings = { };
          extraConfig = ''
            # Subtitles
            --write-auto-subs
            --sub-lang en

            # Metadata
            --embed-metadata

            # Video format webm with best audio
            #-f "bestvideo[ext=webm]+bestaudio/best[ext=webm]/best"
            -f bestvideo+bestaudio/best
            #--merge-output-format webm
            --merge-output-format mkv
            --recode-video mkv
          '';
        };
      };
    };
}
