{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  version = "1.0.238";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    hash = "sha256-ee+3c/70X5fNO+IApwy53GkPzvjW+qLbwpZ5qo9ofYU=";
  };

  extracted = appimageTools.extract {
    pname = "tabby";
    inherit version src;
  };

  appimage = appimageTools.wrapType2 {
    pname = "tabby";
    inherit version src;
  };
in
stdenv.mkDerivation {
  pname = "tabby";
  inherit version;

  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;

  installPhase = ''
    makeWrapper ${appimage}/bin/tabby $out/bin/tabby --add-flags "--no-sandbox"

    install -Dm644 ${extracted}/tabby.desktop $out/share/applications/tabby.desktop
    substituteInPlace $out/share/applications/tabby.desktop \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=tabby %U"

    install -Dm644 ${extracted}/tabby.png $out/share/icons/hicolor/512x512/apps/tabby.png
  '';

  meta = {
    description = "终端模拟器与 SSH/SFTP 客户端";
    homepage = "https://github.com/Eugeny/tabby";
    license = lib.licenses.mit;
    mainProgram = "tabby";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
