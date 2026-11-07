{
  flake.modules.nixos.palette = { config, ... }: {

    hj.windowManagers.hyprland.files =
      with config.palette.baseColors.hex;
      with config.palette.fonts;
      [
        {
          name = "colors";
          order = 0;
          content = # lua
            ''
              focusColor = "rgb(${base0e.withoutHash})"
              unfocusColor = "rgb(${base00.withoutHash})"
              hiddenColor = "rgb(${base12.withoutHash})"
              hiddenFocusedColor = "rgb(${base13.withoutHash})"
            '';
        }
      ];
  };
}
