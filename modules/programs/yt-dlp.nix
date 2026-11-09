{ lib, ... }: {
  flake.modules.nixos.yt-dlp =
    {
      config,
      ...
    }:
    let
      cfg = config.conf.programs.yt-dlp;
    in
    {
      options.conf.programs.yt-dlp = {

        enable = lib.mkEnableOption {
          description = "Enable yt-dlp";
        };

      };

      config = lib.mkIf cfg.enable {

        hj.programs.yt-dlp = {
          enable = true;

          settings = ''
            # Subtitles
            --write-auto-subs
            --sub-lang en

            # Metadata
            --embed-metadata

            # Video: Prefer best WebM video + audio
            -f "bestvideo[ext=webm]+bestaudio[ext=webm]/best[ext=webm]/best"

            # Merge into WebM container
            --merge-output-format webm
            --recode-video webm
          '';
        };

      };
    };
}
