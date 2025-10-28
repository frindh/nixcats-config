{
  description = "Reusable nixCats Neovim configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixCats, flake-utils, ... }:
    let
      # Import nixCats exports
      exports = import ./exports.nix { inherit nixCats nixpkgs; };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        # nix build .  → builds your Neovim package
        packages.default = exports.packages.${system}.default;

        # nix develop  → opens a dev shell with Neovim + dependencies
        devShells.default = exports.devShells.${system}.default;
      }
    )
    // {
      # Home Manager module for easy integration
      homeModules.default = { config, lib, pkgs, ... }: {
        options.nixCats = {
          enable = lib.mkEnableOption "Enable nixCats Neovim setup";
          luaPath = lib.mkOption {
            type = lib.types.path;
            default = ./dotfiles/nvim;
            description = "Path to Neovim configuration files";
          };
        };

        config = lib.mkIf config.nixCats.enable {
          home.packages = [ exports.packages.${pkgs.system}.default ];

          # Create symlink to your config
          home.activation.createNixCatsSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
            rm -rf "$HOME/.config/nixCats-nvim"
            ln -s "${config.nixCats.luaPath}" "$HOME/.config/nixCats-nvim"
          '';
        };
      };
    };
}
