{
  flake.modules.nixos.palette = { config, ... }: {

    programs.spicetify.customColorScheme = with config.palette.baseColors.hex; {
      accent = base0d.withoutHash;
      accent-active = base0d.withoutHash;
      accent-inactive = base03.withoutHash;
      banner = base01.withoutHash;
      border-active = base05.withoutHash;
      border-inactive = base03.withoutHash;
      header = base01.withoutHash;
      highlight = base02.withoutHash;
      main = base00.withoutHash;
      notification = base0c.withoutHash;
      notification-error = base08.withoutHash;
      subtext = base04.withoutHash;
      text = base05.withoutHash;
    };
  };
}
