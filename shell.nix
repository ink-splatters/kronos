with import <nixpkgs> { };
let

  inherit (darwin.apple_sdk) frameworks;

in mkShell.override { inherit (llvmPackages_17) stdenv; } {
  nativeBuildInputs = with frameworks;
    [

      CoreAudio
      AudioUnit
      AudioToolbox
      IOKit
      OpenCL
      CoreMIDI
    ] ++

    [
      iconv
      xcodebuild
      rust-bindgen

    ];

  buildInputs = [

    nixfmt

  ];

}
