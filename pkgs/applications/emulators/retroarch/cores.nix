{ lib
, newScope
, stdenv
, gcc12Stdenv
, alsa-lib
, boost
, bzip2
, cmake
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg_6
, fluidsynth
, fmt
, freetype
, gettext
, harfbuzz
, hexdump
, hidapi
, icu
, libaio
, libevdev
, libGL
, libGLU
, libjpeg
, liblcf
, libpcap
, libpng
, libsndfile
, libvorbis
, libxml2
, libxmp
, libzip
, mpg123
, nasm
, openssl
, opusfile
, pcre
, pixman
, pkg-config
, portaudio
, python3
, sfml
, snappy
, speexdsp
, udev
, which
, xorg
, xxd
, xz
}:

let
  hashesFile = lib.importJSON ./hashes.json;

  getCore = repo: (lib.getAttr repo hashesFile);

  getCoreSrc = repo:
    let
      inherit (getCore repo) src fetcher;
      fetcherFn = {
        inherit fetchFromGitHub;
      }.${fetcher} or (throw "Unknown fetcher: ${fetcher}");
    in
    fetcherFn src;

  getCoreVersion = repo: (getCore repo).version;
in
lib.makeScope newScope (self: rec {
  mkLibretroCore =
    # Sometimes core name != repo name, so you may need to set them differently
    # when necessary:
    # - core: used by the resulting core library name, e.g.:
    #   `${core}_libretro.so`. Needs to match their respectful core info file
    #   (see https://github.com/libretro/libretro-core-info/)
    # - repo: the repository name on GitHub
    # See `update_cores.py` for instruction on how to add a new core.
    { core
    , repo ? core
    , src ? (getCoreSrc repo)
    , version ? (getCoreVersion repo)
    , ...
    }@args:
    self.callPackage ./mkLibretroCore.nix ({
      inherit core repo src version;
    } // args);

  atari800 = self.callPackage ./cores/atari800.nix { };

  beetle-gba = self.callPackage ./cores/beetle-gba.nix { };

  beetle-lynx = self.callPackage ./cores/beetle-lynx.nix { };

  beetle-ngp = self.callPackage ./cores/beetle-ngp.nix { };

  beetle-pce = self.callPackage ./cores/beetle-pce.nix { };

  beetle-pce-fast = self.callPackage ./cores/beetle-pce-fast.nix { };

  beetle-pcfx = self.callPackage ./cores/beetle-pcfx.nix { };

  beetle-psx = self.callPackage ./cores/beetle-psx.nix { };

  beetle-psx-hw = self.beetle-psx.override { withHw = true; };

  beetle-saturn = self.callPackage ./cores/beetle-saturn.nix { };

  beetle-supafaust = self.callPackage ./cores/beetle-supafaust.nix { };

  beetle-supergrafx = self.callPackage ./cores/beetle-supergrafx.nix { };

  beetle-vb = self.callPackage ./cores/beetle-vb.nix { };

  beetle-wswan = self.callPackage ./cores/beetle-wswan.nix { };

  blastem = self.callPackage ./cores/blastem.nix { };

  bluemsx = self.callPackage ./cores/bluemsx.nix { };

  bsnes = self.callPackage ./cores/bsnes.nix { };

  bsnes-hd = self.callPackage ./cores/bsnes-hd.nix { };

  bsnes-mercury = self.callPackage ./cores/bsnes-mercury.nix { };

  bsnes-mercury-balanced = self.bsnes-mercury.override { withProfile = "balanced"; };

  bsnes-mercury-performance = self.bsnes-mercury.override { withProfile = "performance"; };

  citra = self.callPackage ./cores/citra.nix {  };

  desmume = self.callPackage ./cores/desmume.nix {  };

  desmume2015 = self.callPackage ./cores/desmume2015.nix {  };

  dolphin = self.callPackage ./cores/dolphin.nix {  };

  dosbox = self.callPackage ./cores/dosbox.nix {  };

  dosbox-pure = self.callPackage ./cores/dosbox-pure.nix {  };

  easyrpg = self.callPackage ./cores/easyrpg.nix {  };

  eightyone = self.callPackage ./cores/eightyone.nix {  };

  fbalpha2012 = self.callPackage ./cores/fbalpha2012.nix {  };

  fbneo = self.callPackage ./cores/fbneo.nix {  };

  fceumm = self.callPackage ./cores/fceumm.nix {  };

  flycast = self.callPackage ./cores/flycast.nix {  };

  fmsx = self.callPackage ./cores/fmsx.nix {  };

  freeintv = self.callPackage ./cores/freeintv.nix {  };

  fuse = self.callPackage ./cores/fuse.nix {  };

  gambatte = self.callPackage ./cores/gambatte.nix {  };

  genesis-plus-gx = self.callPackage ./cores/genesis-plus-gx.nix {  };

  gpsp = self.callPackage ./cores/gpsp.nix {  };

  gw = self.callPackage ./cores/gw.nix {  };

  handy = self.callPackage ./cores/handy.nix {  };

  hatari = self.callPackage ./cores/hatari.nix {  };

  mame = self.callPackage ./cores/mame.nix {  };

  mame2000 = self.callPackage ./cores/mame2000.nix {  };

  mame2003 = self.callPackage ./cores/mame2003.nix {  };

  mame2003-plus = self.callPackage ./cores/mame2003-plus.nix {  };

  mame2010 = self.callPackage ./cores/mame2010.nix {  };

  mame2015 = self.callPackage ./cores/mame2015.nix {  };

  mame2016 = self.callPackage ./cores/mame2016.nix {  };

  melonds = self.callPackage ./cores/melonds.nix {  };

  mesen = self.callPackage ./cores/mesen.nix {  };

  mesen-s = self.callPackage ./cores/mesen-s.nix {  };

  meteor = self.callPackage ./cores/meteor.nix {  };

  mgba = self.callPackage ./cores/mgba.nix {  };

  mrboom = self.callPackage ./cores/mrboom.nix {  };

  mupen64plus = self.callPackage ./cores/mupen64plus.nix {  };

  neocd = self.callPackage ./cores/neocd.nix {  };

  nestopia = self.callPackage ./cores/nestopia.nix {  };

  np2kai = self.callPackage ./cores/np2kai.nix {  };

  nxengine = self.callPackage ./cores/nxengine.nix {  };

  o2em = self.callPackage ./cores/o2em.nix {  };

  opera = self.callPackage ./cores/opera.nix {  };

  parallel-n64 = self.callPackage ./cores/parallel-n64.nix {  };

  pcsx2 = self.callPackage ./cores/pcsx2.nix {  };

  pcsx-rearmed = self.callPackage ./cores/pcsx-rearmed.nix {  };
  pcsx_rearmed = lib.lowPrio(self.pcsx-rearmed); # added 2024-11-20

  picodrive = self.callPackage ./cores/picodrive.nix {  };

  play = self.callPackage ./cores/play.nix {  };

  ppsspp = self.callPackage ./cores/ppsspp.nix {  };

  prboom = self.callPackage ./cores/prboom.nix {  };

  prosystem = self.callPackage ./cores/prosystem.nix {  };

  puae = self.callPackage ./cores/puae.nix {  };

  quicknes = self.callPackage ./cores/quicknes.nix {  };

  same_cdi = self.callPackage ./cores/same_cdi.nix {  }; # the name is not a typo

  sameboy = self.callPackage ./cores/sameboy.nix {  };

  scummvm = self.callPackage ./cores/scummvm.nix {  };

  smsplus-gx = self.callPackage ./cores/smsplus-gx.nix {  };

  snes9x = self.callPackage ./cores/snes9x.nix {  };

  snes9x2002 = self.callPackage ./cores/snes9x2002.nix {  };

  snes9x2005 = self.callPackage ./cores/snes9x2005.nix {  };

  snes9x2005-plus = self.snes9x2005.override { withBlarggAPU = true; };

  snes9x2010 = self.callPackage ./cores/snes9x2010.nix {  };

  stella = self.callPackage ./cores/stella.nix {  };

  stella2014 = self.callPackage ./cores/stella2014.nix {  };

  swanstation = mkLibretroCore {
    core = "swanstation";
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DBUILD_LIBRETRO_CORE=ON"
    ];
    meta = {
      description = "Port of SwanStation (a fork of DuckStation) to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  tgbdual = mkLibretroCore {
    core = "tgbdual";
    makefile = "Makefile";
    meta = {
      description = "Port of TGBDual to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  thepowdertoy = mkLibretroCore {
    core = "thepowdertoy";
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    postBuild = "cd src";
    meta = {
      description = "Port of The Powder Toy to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  tic80 = mkLibretroCore {
    core = "tic80";
    extraNativeBuildInputs = [ cmake pkg-config ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DBUILD_LIBRETRO=ON"
      "-DBUILD_DEMO_CARTS=OFF"
      "-DBUILD_PRO=OFF"
      "-DBUILD_PLAYER=OFF"
      "-DBUILD_SDL=OFF"
      "-DBUILD_SOKOL=OFF"
    ];
    preConfigure = "cd core";
    postBuild = "cd lib";
    meta = {
      description = "Port of TIC-80 to libretro";
      license = lib.licenses.mit;
    };
  };

  twenty-fortyeight = mkLibretroCore {
    core = "2048";
    meta = {
      description = "Port of 2048 puzzle game to the libretro API";
      license = lib.licenses.unlicense;
    };
  };

  vba-m = mkLibretroCore {
    core = "vbam";
    repo = "vba-m";
    makefile = "Makefile";
    preBuild = "cd src/libretro";
    meta = {
      description = "vanilla VBA-M libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  vba-next = mkLibretroCore {
    core = "vba-next";
    meta = {
      description = "VBA-M libretro port with modifications for speed";
      license = lib.licenses.gpl2Only;
    };
  };

  vecx = mkLibretroCore {
    core = "vecx";
    extraBuildInputs = [ libGL libGLU ];
    meta = {
      description = "Port of Vecx to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  virtualjaguar = mkLibretroCore {
    core = "virtualjaguar";
    makefile = "Makefile";
    meta = {
      description = "Port of VirtualJaguar to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  yabause = mkLibretroCore {
    core = "yabause";
    makefile = "Makefile";
    # Disable SSE for non-x86. DYNAREC doesn't build on aarch64.
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
    preBuild = "cd yabause/src/libretro";
    meta = {
      description = "Port of Yabause to libretro";
      license = lib.licenses.gpl2Only;
    };
  };
})
