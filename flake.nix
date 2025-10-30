{
  description = "Reusable nixCats Neovim configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Consider using unstable
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixCats, flake-utils, ... }:
    let
      exports = import ./exports.nix { inherit nixCats nixpkgs; };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages = {
          default = exports.packages.${system}.nixCats;
          minimal = exports.packages.${system}.minimal;
        };

        devShells.default = exports.devShells.${system}.default;
      }
    ) // {
      # Simplified home manager module
      homeManagerModules.default = exports.homeModules.default;
      nixosModules.default = exports.nixosModules.default;
      overlays.default = exports.overlays.default;
    };
}
