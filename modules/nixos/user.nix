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
          mutableUsers = true;
          users."${username}" = {
            isNormalUser = true;
            group = username;
            description = username;
            initialPassword = "12345";
          };
          groups.${username} = { };
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
