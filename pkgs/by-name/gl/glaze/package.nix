{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  avx2 ? false,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    rev = "v${final.version}";
    hash = "sha256-zaGKYEnYTyAhtP0Hywxp8Y33wvjB1RkEoOGF41CaVnY";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-Dglaze_ENABLE_AVX2=${if avx2 then "ON" else "OFF"}" ];

  meta = with lib; {
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
    license = licenses.mit;
  };
})
