{ pkgs, ... }: {
  plugins.telescope = {
    enable = true;

    extensions.fzf-native.enable = true;
  };

  extraPackages = [
    pkgs.ripgrep # required for explorer search
  ];
}
