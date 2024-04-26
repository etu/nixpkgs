{
  cmake,
  fetchFromGitHub,
  lib,
  lib3mf,
  pkg-config,
  stdenv
}:
let
  pname = "3mfmerge";
  version = "0.5.1";
in
stdenv.mkDerivation {
  inherit pname version;

  buildInputs = [ lib3mf ];
  nativeBuildInputs = [ cmake pkg-config ];

  src = fetchFromGitHub {
    owner = "jschobben";
    repo = "colorscad";
    rev = "v${version}";
    hash = "sha256-MkRzC8y9yxFnNfoXmDv5/M1My5S0G+dZpBr5rMLwSyw=";
  };

  sourceRoot = "source/${pname}";

  # Override the CMakeLists.txt to use the lib3mf from the nix store
  # instead of relying on a download from the internet.
  #
  # Then also patch it to have the right paths.
  prePatch = ''
    cp ${./CMakeLists.txt} CMakeLists.txt

    substituteInPlace CMakeLists.txt \
      --replace @lib3mfDev@ ${lib3mf.dev}
  '';

  installPhase = ''
    install -Dm755 ../bin/3mfmerge -t $out/bin
  '';

  meta = {
    description = "TMerge a set of .3mf models into one file";
    homepage = "https://github.com/jschobben/colorscad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ etu ];
    platforms = lib.platforms.linux;
    mainProgram = "3mfmerge";
  };
}
