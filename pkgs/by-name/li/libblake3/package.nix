{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    tag = finalAttrs.version;
    hash = "sha256-YJ3rRzpmF6oS8p377CEoRteARCD1lr/L7/fbN5poUXw=";
  };

  sourceRoot = finalAttrs.src.name + "/c";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Official C implementation of BLAKE3";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/tree/master/c";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
