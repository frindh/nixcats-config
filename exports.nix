# pkgs/nixcats-exports.nix
{nixCats, nixpkgs, ...}: let
  utils = nixCats.utils;
  # path in the store
  luaPath = ./.;

  # small category / package definitions — extend later
  categoryDefinitions = {pkgs, ...}: {
    lspsAndRuntimeDeps.general = with pkgs; [
      nixd
      alejandra
      lua-language-server

      # python
      ruff
      pyright

      gopls

      # clipboard in wayland
      wl-clipboard
    ];

    startupPlugins.general = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      oil-nvim
      kanagawa-nvim
    ];
  };

  packageDefinitions = {
    nixCats = {
      pkgs,
      name,
      ...
    }: {
      settings = {
        wrapRc = false;  # lua files will not be copied into the store, handle it separately with activation script
        suffix-path = true;
        suffix-LD = true;
        configDirName = "nixCats-nvim";
        aliases = ["nvim"];
        hosts.python3.enable = true;
        hosts.node.enable = true;
      };
      categories = {general = true;};
      extra = {};
    };
  };

  defaultPackageName = "nixCats";

  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
in
  # Build per-system outputs (packages/devShells) then add cross-system modules/overlays
  forEachSystem (
    system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit system nixpkgs;
        }
        categoryDefinitions
        packageDefinitions;

      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
        };
      };
    }
  )
  // {
    # Export NixOS & Home Manager modules (not per-system)
    nixosModules.default = utils.mkNixosModules {
      moduleNamespace = [defaultPackageName];
      inherit defaultPackageName categoryDefinitions packageDefinitions nixpkgs luaPath;
    };

    homeModules.default = utils.mkHomeModules {
      moduleNamespace = [defaultPackageName];
      inherit defaultPackageName categoryDefinitions packageDefinitions nixpkgs luaPath;
    };

    overlays =
      utils.makeOverlays luaPath {
        inherit nixpkgs;
      }
      categoryDefinitions
      packageDefinitions
      defaultPackageName;

    inherit utils;
  }
