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
