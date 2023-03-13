{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [rust-overlay.overlays.default];
      };
    in {
      devShell = pkgs.mkShell {
        shellHook = ''
          export CC=$(which clang)
        '';
        packages = with pkgs; [
          alejandra
          rustfmt
          rust-analyzer
          wabt
          clang

          (rust-bin.stable."1.66.0".default.override {
            targets = ["wasm32-unknown-unknown"];
          })
        ];
      };
    });
}
