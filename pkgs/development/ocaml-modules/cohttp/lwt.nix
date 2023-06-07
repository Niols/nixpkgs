{ lib, buildDunePackage
, cohttp, lwt, uri, ppx_sexp_conv, logs, sexplib0, fieldslib
}:

buildDunePackage {
  pname = "cohttp-lwt";
  inherit (cohttp)
    version
    src
    ;

  duneVersion = "3";

  buildInputs = [
    fieldslib
    ppx_sexp_conv
  ];

  propagatedBuildInputs = [
    cohttp lwt logs sexplib0 uri
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
