{
  lib,
  stdenv,
  overrideSDK,
  fetchurl,
  pkg-config,
  gnutls,
  libedit,
  texinfo,
  libcap,
  libseccomp,
  pps-tools,
  nixosTests,
}:

let
  stdenv' =
    if stdenv.hostPlatform.isDarwin then
      overrideSDK stdenv {
        darwinSdkVersion = "11.0";
        darwinMinVersion = "10.13";
      }
    else
      stdenv;
in
stdenv'.mkDerivation rec {
  pname = "chrony";
  version = "4.5";

  src = fetchurl {
    url = "https://download.tuxfamily.org/chrony/${pname}-${version}.tar.gz";
    hash = "sha256-Gf4dn0Zk1EWmmpbHHo/bYLzY3yTHPROG4CKH9zZq1CI=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      gnutls
      libedit
      texinfo
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
      libseccomp
      pps-tools
    ];

  configureFlags = [
    "--enable-ntp-signd"
    "--sbindir=$(out)/bin"
    "--chronyrundir=/run/chrony"
  ] ++ lib.optional stdenv.hostPlatform.isLinux "--enable-scfilter";

  patches = [
    # Cleanup the installation script
    ./makefile.patch
  ];

  postPatch = ''
    patchShebangs test
  '';

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  passthru.tests = {
    inherit (nixosTests) chrony chrony-ptp;
  };

  meta = {
    description = "Sets your computer's clock from time servers on the Net";
    homepage = "https://chrony.tuxfamily.org/";
    license = lib.licenses.gpl2Only;
    platforms =
      with lib.platforms;
      builtins.concatLists [
        linux
        freebsd
        netbsd
        darwin
        illumos
      ];
    maintainers = with lib.maintainers; [
      fpletz
      thoughtpolice
      vifino
    ];

    longDescription = ''
      Chronyd is a daemon which runs in background on the system. It obtains
      measurements via the network of the system clock’s offset relative to
      time servers on other systems and adjusts the system time accordingly.
      For isolated systems, the user can periodically enter the correct time by
      hand (using Chronyc). In either case, Chronyd determines the rate at
      which the computer gains or loses time, and compensates for this. Chronyd
      implements the NTP protocol and can act as either a client or a server.

      Chronyc provides a user interface to Chronyd for monitoring its
      performance and configuring various settings. It can do so while running
      on the same computer as the Chronyd instance it is controlling or a
      different computer.
    '';
  };
}
