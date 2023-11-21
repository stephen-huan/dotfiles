{ lib
, buildNpmPackage
, fetchFromGitHub
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

  patches = [ ./git_sha.patch ];

  strictDeps = true;
  nativeBuildInputs = [ nodejs ];

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
