{ lib, ... }: {
  flake.modules.nixos.user =
    {
      config,
      username,
      ...
    }:
    {
      options.conf.user = {
        enable = lib.mkEnableOption { };
      };

      config =
        let
          cfg = config.conf.user;
        in
        lib.mkIf cfg.enable {

          # Sops secrets
          # sops.secrets = {
          #   "linux-password" = {
          #     neededForUsers = true; # Requried for pre-user-creation
          #   };
          # };

          users = {
            mutableUsers = true;

            # Root
            # users.root.hashedPasswordFile = config.sops.secrets."linux-password".path;

            # Main usesr
            users."${username}" = {
              initialPassword = "12345";
              # hashedPasswordFile = config.sops.secrets."linux-password".path;
              isNormalUser = true;
              description = "${username}";
              extraGroups = [
                "wheel"
                "network"
              ];
            };
          };

          # Localization
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
          # TODO: fix this whole ass file
          # Home Manager
          hm =
            let
              user = username;
            in
            {
              home = {
                username = "${user}";
                homeDirectory = "/home/${user}";
                preferXdgDirectories = true;

                sessionVariables = {
                  EDITOR = "nvim";
                  VISUAL = "nvim";
                };
              };

              services.syncthing = {
                enable = true;
                tray = {
                  enable = false;
                };
              };

              xdg = {
                enable = true;

                # Default directories
                userDirs =
                  let
                    homeDirectory = "${config.home-manager.users.${user}.home.homeDirectory}";
                  in
                  {
                    enable = true;
                    createDirectories = true;
                    desktop = "${homeDirectory}/desktop";
                    documents = "${homeDirectory}/documents";
                    download = "${homeDirectory}/downloads";
                    music = "${homeDirectory}/music";
                    pictures = "${homeDirectory}/pictures";
                    videos = "${homeDirectory}/videos";
                    publicShare = "${homeDirectory}/public";
                    templates = "${homeDirectory}/templates";

                    # Development and testing directories
                    extraConfig = {
                      XDG_DEVELOPMENT_DIR = "${homeDirectory}/development";
                      XDG_TMP_DIR = "${homeDirectory}/temp";
                    };
                  };

                # Default applications for file types
                mimeApps.enable = true;
              };
            };
        };
    };
}
