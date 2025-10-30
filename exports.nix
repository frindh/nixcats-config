{nixCats, nixpkgs, ...}: let
  utils = nixCats.utils;
  # path to location with init.lua and lua directory
  luaPath = ./nvim;

  categoryDefinitions = {pkgs, ...}: {
    # Core tools always included
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        wl-clipboard
      ];

      # Language-specific categories
      nix = with pkgs; [
        nixd
        alejandra
      ];

      lua = with pkgs; [
        lua-language-server
      ];

      python = with pkgs; [
        ruff
        pyright
      ];

      go = with pkgs; [
        gopls
      ];
    };

    startupPlugins = {
      general = with pkgs.vimPlugins; [
        telescope-nvim
        telescope-fzf-native-nvim
        plenary-nvim
        oil-nvim
        kanagawa-nvim
      ];

      lsp = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];

      treesitter = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };
  };

  packageDefinitions = {
    # Minimal configuration
    minimal = {pkgs, name, ...}: {
      settings = {
        wrapRc = true;  # Let nixCats handle the config
        configDirName = "nixCats";
        aliases = ["nvim"];
      };
      categories = {
        general = true;
        lsp = true;
        # Other categories false by default
      };
    };

    # Full development environment
    nixCats = {pkgs, name, ...}: {
      settings = {
        wrapRc = true;
        configDirName = "nixCats";
        aliases = ["nvim"];
        hosts.python3.enable = true;
        hosts.node.enable = true;
      };
      categories = {
        general = true;
        lsp = true;
        treesitter = true;
        nix = true;
        lua = true;
        python = true;
        go = true;
      };
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
