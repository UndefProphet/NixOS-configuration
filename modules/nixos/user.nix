{
  lib,
  ...
}:
{
  flake.modules.nixos.user =
    {
      config,
      username,
      ...
    }:
    let
      cfg = config.conf.user;
    in
    {
      options.conf.user = {
        enable = lib.mkEnableOption { };
      };

      config = lib.mkIf cfg.enable {
        users = {
          mutableUsers = false;
          users = {
            # Root user
            root.hashedPasswordFile = config.sops.secrets."linux-password".path;

            # Main user
            "${username}" = {
              isNormalUser = true;
              group = username;
              description = username;
              extraGroups = [ "wheel" ];
              hashedPasswordFile = config.sops.secrets."linux-password".path;
            };
          };

          groups.${username} = { };
        };

        time.timeZone = lib.mkDefault "Europe/Stockholm";
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "sv_SE.UTF-8";
            LC_IDENTIFICATION = "sv_SE.UTF-8";
            LC_MEASUREMENT = "sv_SE.UTF-8";
            LC_MONETARY = "sv_SE.UTF-8";
            LC_NAME = "sv_SE.UTF-8";
            LC_NUMERIC = "sv_SE.UTF-8";
            LC_PAPER = "sv_SE.UTF-8";
            LC_TELEPHONE = "sv_SE.UTF-8";
            LC_TIME = "sv_SE.UTF-8";
          };
        };

        hj.xdg.userDirs = {
          enable = true;
          create = true;

          desktop = "desktop";
          documents = "documents";
          download = "downloads";
          music = "music";
          pictures = "pictures";
          videos = "videos";
          publicShare = "public";
          templates = "templates";

          # Non standard
          screenshots = "pictures/screenshots";
          development = "development";
          tmp = "temp";
        };
      };
    };
}
