{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  fontconfig,

  zlib,
  libGL,
  libX11,
  libsecret,
  e2fsprogs,
  libnotify,
  pam,
  audit,
  systemd,
  git,
  which,
  python3,
  
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxxf86vm,
  
  pkgs
}: let
  pname = "idea";
  version = pkgs.jetbrains.idea.version;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      hash = "sha256-o0QsnxlTxm3LCCXpt4jH5077WG7b8dMO+LDfVT/hNuQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIU-${version}-aarch64.tar.gz";
      hash = "sha256-h1FtLwe47B/2z+nRTWj8P3b11XuGYRMlueq6wbYEPMs=";
    };
  };

  runtimeLibs = [
    fontconfig
    zlib
    libGL
    libX11
    libsecret
    e2fsprogs
    libnotify
    libxext
    libxi
    libxrender
    libxtst
    libxxf86vm
  ];
in
  stdenv.mkDerivation {
    inherit pname version;

    src = sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    nativeBuildInputs = [makeWrapper autoPatchelfHook copyDesktopItems];

    buildInputs = [stdenv.cc.cc.lib pam audit systemd] ++ runtimeLibs;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/${pname},share/pixmaps}
      cp -r . $out/share/${pname}

      # remove problematic folder
      rm -rf $out/share/idea/plugins/remote-dev-server/selfcontained/

      # for desktop icon
      ln -s $out/share/idea/bin/idea.svg $out/share/pixmaps/${pname}.svg

      makeWrapper $out/share/idea/bin/idea $out/bin/${pname} \
        --prefix PATH : ${lib.makeBinPath [git which python3]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
        --set FONTCONFIG_FILE ${fontconfig.out}/etc/fonts/fonts.conf

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = "IntelliJ IDEA Ultimate";
        genericName = "Java IDE";
        comment = "Java, Kotlin, Groovy and Scala IDE from JetBrains";
        categories = ["Development" "IDE"];
        startupWMClass = "jetbrains-idea";
      })
    ];

    meta = {
      description = "IntelliJ IDEA Ultimate Edition";
      homepage = "https://www.jetbrains.com/idea/";
      license = lib.licenses.unfree;
      platforms = lib.attrNames sources;
      mainProgram = pname;
    };
  }
