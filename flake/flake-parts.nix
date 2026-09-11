{ inputs, ... }: {
  tack.inputs = {
    # https://github.com/hercules-ci/flake-parts
    # flake-parts provides the options that represent standard flake attributes and establishes a way of working with system.
    flake-parts = "gh:hercules/flake-parts?ref=main";

    # https://github.com/denful/import-tree
    # Recursively import Nix modules from a directory, with a simple, extensible API.
    import-tree = "gh:denful/import-tree?ref=main";
  };

  imports = [ inputs.flake-parts.flakeModules.modules ];

  debug = true;
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
}
