{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.conf.terminal.yazi.enable {
    hm = {
      programs.yazi = {

        extraPackages = with pkgs; [
          git
          lazygit
        ];

        plugins = with pkgs.yaziPlugins; {
          git = {
            package = git;
            setup = true;
            settings = {
              order = 1500;
            };
          };
        };

        settings = {
          plugin.prepend_fetchers = [
            {
              id = "git";
              group = "git";
              url = "*";
              run = "git";
            }
            {
              id = "git";
              group = "git";
              url = "*/";
              run = "git";
            }
          ];
        };

        theme = {
          git = {
            unknown_sign = "?";
            modified_sign = "M";
            added_sign = "A";
            deleted_sign = "D";
            untracked_sign = "U";
            clean_sign = " ";
          };
        };
      };
    };
  };
}
