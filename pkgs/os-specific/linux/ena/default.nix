{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  kernel,
}:
let
  rev-prefix = "ena_linux_";
  version = "2.13.0";
in
stdenv.mkDerivation {
  inherit version;
  name = "ena-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${version}";
    hash = "sha256-uYWKu9M/5PcHV4WdMSi0f29S7KnQft67dgjdN0AS1d8=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  env.KERNEL_BUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  configurePhase = ''
    runHook preConfigure
    cd kernel/linux/ena
    export ENA_PHC_INCLUDE=1
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    $STRIP -S ena.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp ena.ko $dest/
    xz $dest/ena.ko
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    inherit rev-prefix;
  };

  meta = with lib; {
    description = "Amazon Elastic Network Adapter (ENA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      sielicki
      arianvp
    ];
    platforms = platforms.linux;
  };
}
