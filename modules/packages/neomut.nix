{ lib, ... }: {
  flake.modules.nixos.neomutt =
    { config, ... }:
    let
      cfg = config.conf.packages.neomutt;
    in
    {
      options.conf.packages.neomutt.enable = lib.mkEnableOption {
        description = "Enable neomutt";
      };

      config = lib.mkIf cfg.enable {
        hm.programs.neomutt = {
          enable = true;
          vimKeys = true;
        };
      };
    };
}
