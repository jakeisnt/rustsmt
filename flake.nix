{
  description = "TODO";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        inherit (lib) attrValues;
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
        package = with pkgs; callPackage ./. { inherit pkgs; };
      in {
        devShell = with pkgs; mkShell {
          buildInputs = [ cargo rustup rustc z3 rustfmt rust-analyzer lld clang llvmPackages.libclang ];
          LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
        };
        defaultPackage = package;
      });
}
