{
  description = "edge-shaper: nixpkgs edge package collection";

  nixConfig = {
    extra-substituters = "https://aarch64-darwin.cachix.org";
    extra-trusted-public-keys =
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA=";
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # pkgs = import nixpkgs {
        #   inherit system;

        #   overlays = [
        #     (final: prev: let
        #         inherit (fenix.packages.${system}.minimal) toolchain;
        #         cargo=toolchain;
        #         rustc=toolchain;
        #     in {

        #       rustPlatform = (prev.makeRustPlatform {
        #           inherit cargo rustc;
        #       });
        #     })
        #   ];

        pkgs = nixpkgs.legacyPackages.${system};
        inherit (fenix.packages.${system}.minimal) toolchain;
	inherit (pkgs.darwin.apple_sdk) frameworks;
        # };
      in with pkgs; {
        formatter = nixfmt;
        packages.default =
          mkShell.override { inherit (llvmPackages_17) stdenv; } {
            nativeBuildInputs =
              with frameworks; [
		AudioToolbox
		AudioUnit
		CoreAudio
		CoreMIDI
		OpenCL
		IOKit

	      ] ++ [ llvmPackages_17.bintools toolchain iconv ];

            RUST_SRC_PATH =
              "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

          };
      });
}
