{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ppx_fields_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
  version = "2.5.8";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    sha256 = "sha256-JyJHfR9bsJ6EHevBJcMP9E8bIM+IlLaMtI8rbeCS0lo=";
  };

  buildInputs = [
    jsonm
    ppx_sexp_conv
    ppx_fields_conv
  ];

  propagatedBuildInputs = [ base64 re stringext uri-sexp ];

  doCheck = true;
  checkInputs = [ fmt alcotest crowbar ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
