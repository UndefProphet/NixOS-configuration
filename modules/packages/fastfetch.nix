{ lib, ... }: {
  flake.modules.nixos.fastfetch = { config, ... }: {

    hm.programs.fastfetch = {

    };

  };
}
