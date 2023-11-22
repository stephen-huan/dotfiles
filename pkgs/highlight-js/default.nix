{ lib
, buildNpmPackage
, fetchFromGitHub
, writeShellScriptBin
, nodejs
, minified ? true
, modules ? true
, target ? "browser"
, languages ? [ ":common" ]
}:

buildNpmPackage rec {
  pname = "highlight-js";
  version = "11.9.0";

  src = fetchFromGitHub {
    owner = "highlightjs";
    repo = "highlight.js";
    rev = version;
    hash = "sha256-vjENgkzRmpSiXrt7vydLNTpD3nh4bGjo5G6n2ySkM/4=";
  };

  npmDepsHash = "sha256-YhD3HADU7sjDDtnNfemH5QGz+A0G2FEfsWUgAjEflJY=";

  # https://github.com/NixOS/nixpkgs/issues/107556
  # spoof `git rev-parse --short=10 HEAD`
  fakegit = writeShellScriptBin "git" ''
    echo ${builtins.substring 0 10 "f47103d4f1ac1592c56904574d1fbf5bf2475605"}
  '';

  strictDeps = true;
  nativeBuildInputs = [ nodejs fakegit ];

  buildPhase = ''
    runHook preBuild

    node tools/build.js \
      ${if ! minified then "--no-minify" else ""} \
      ${if ! modules then "--no-esm" else ""} \
      --target "${target}" \
      ${builtins.concatStringsSep " " languages}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/highlight${if minified then ".min" else ""}.js -t $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Syntax highlighting with language autodetection";
    homepage = "https://highlightjs.org";
    license = licenses.bsd3;
    inherit (nodejs.meta) platforms;
    maintainers = [ ];
  };
}
