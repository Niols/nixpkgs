{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  davix,
  cmake,
  cppunit,
  gtest,
  makeWrapper,
  pkg-config,
  curl,
  isa-l,
  fuse,
  libkrb5,
  libuuid,
  libxcrypt,
  libxml2,
  openssl,
  readline,
  scitokens-cpp,
  systemd,
  voms,
  zlib,
  # Build bin/test-runner
  enableTestRunner ? true,
  # If not null, the builder will
  # move "$out/etc" to "$out/etc.orig" and symlink "$out/etc" to externalEtc.
  externalEtc ? "/etc",
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrootd";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZU31nsQgs+Gz9mV8LVv4utJ7g8TXN5OxHjNDfQlt38M=";
  };

  postPatch =
    ''
      patchShebangs genversion.sh
      substituteInPlace cmake/XRootDConfig.cmake.in \
        --replace-fail "@PACKAGE_CMAKE_INSTALL_" "@CMAKE_INSTALL_FULL_"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i cmake/XRootDOSDefs.cmake -e '/set( MacOSX TRUE )/ainclude( GNUInstallDirs )'
    '';

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ] ++ lib.optional (externalEtc != null) "etc";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    removeReferencesTo
  ];

  buildInputs =
    [
      davix
      curl
      isa-l
      libkrb5
      libuuid
      libxcrypt
      libxml2
      openssl
      readline
      scitokens-cpp
      zlib
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      # https://github.com/xrootd/xrootd/blob/5b5a1f6957def2816b77ec773c7e1bfb3f1cfc5b/cmake/XRootDFindLibs.cmake#L58
      fuse
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      systemd
      voms
    ]
    ++ lib.optionals enableTestRunner [
      gtest
      cppunit
    ];

  # https://github.com/xrootd/xrootd/blob/master/packaging/rhel/xrootd.spec.in#L665-L675=
  postInstall =
    ''
      mkdir -p "$out/lib/tmpfiles.d"
      install -m 644 -T ../packaging/rhel/xrootd.tmpfiles "$out/lib/tmpfiles.d/xrootd.conf"
      mkdir -p "$out/etc/xrootd"
      install -m 644 -t "$out/etc/xrootd" ../packaging/common/*.cfg
      install -m 644 -t "$out/etc/xrootd" ../packaging/common/client.conf
      mkdir -p "$out/etc/xrootd/client.plugins.d"
      install -m 644 -t "$out/etc/xrootd/client.plugins.d" ../packaging/common/client-plugin.conf.example
      mkdir -p "$out/etc/logrotate.d"
      install -m 644 -T ../packaging/common/xrootd.logrotate "$out/etc/logrotate.d/xrootd"
    ''
    # Leaving those in bin/ leads to a cyclic reference between $dev and $bin
    # This happens since https://github.com/xrootd/xrootd/commit/fe268eb622e2192d54a4230cea54c41660bd5788
    # So far, this xrootd-config script does not seem necessary in $bin
    + ''
      moveToOutput "bin/xrootd-config" "$dev"
      moveToOutput "bin/.xrootd-config-wrapped" "$dev"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out/lib/systemd/system"
      install -m 644 -t "$out/lib/systemd/system" ../packaging/common/*.service ../packaging/common/*.socket
    '';

  cmakeFlags =
    [
      "-DXRootD_VERSION_STRING=${finalAttrs.version}"
      "-DFORCE_ENABLED=TRUE"
      "-DENABLE_DAVIX=TRUE"
      "-DENABLE_FUSE=${if (!stdenv.hostPlatform.isDarwin) then "TRUE" else "FALSE"}" # not supported
      "-DENABLE_MACAROONS=OFF"
      "-DENABLE_PYTHON=FALSE" # built separately
      "-DENABLE_SCITOKENS=TRUE"
      "-DENABLE_VOMS=${if stdenv.hostPlatform.isLinux then "TRUE" else "FALSE"}"
    ]
    ++ lib.optionals enableTestRunner [
      "-DENABLE_TESTS=TRUE"
    ];

  postFixup = lib.optionalString (externalEtc != null) ''
    moveToOutput etc "$etc"
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  dontPatchELF = true; # shrinking rpath will cause runtime failures in dlopen

  passthru = {
    fetchxrd = callPackage ./fetchxrd.nix { xrootd = finalAttrs.finalPackage; };
    tests = {
      test-xrdcp = finalAttrs.passthru.fetchxrd {
        pname = "xrootd-test-xrdcp";
        # Use the the bin output hash of xrootd as version to ensure that
        # the test gets rebuild everytime xrootd gets rebuild
        version =
          finalAttrs.version
          + "-"
          + builtins.substring (builtins.stringLength builtins.storeDir + 1) 32 "${finalAttrs.finalPackage}";
        url = "root://eospublic.cern.ch//eos/opendata/alice/2010/LHC10h/000138275/ESD/0000/AliESDs.root";
        hash = "sha256-tIcs2oi+8u/Qr+P7AAaPTbQT+DEt26gEdc4VNerlEHY=";
      };
    };
  };

  meta = {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    changelog = "https://github.com/xrootd/xrootd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
