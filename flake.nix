{
  description = "TODO";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, utils, rust-overlay, ... }:
  utils.lib.eachDefaultSystem (system:
  let
    inherit (lib) attrValues;
    overlays = [ (import rust-overlay) ];
    pkgs = import nixpkgs {
      inherit system overlays;
    };
    lib = nixpkgs.lib;
    package = with pkgs; callPackage ./. { inherit pkgs; };
  in {
    devShell = with pkgs; mkShell {
      buildInputs = [ z3 rustfmt rust-analyzer lld clang llvmPackages.libclang rust-bin.nightly.latest.default ];
      LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  };
  defaultPackage = package;
});
}
