{
  description = "Tabby terminal (Eugeny/tabby) packaged from the official AppImage";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      version = "1.0.238";

      appimage = pkgs.appimageTools.wrapType2 {
        pname = "tabby";
        inherit version;
        src = pkgs.fetchurl {
          url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
          hash = "sha256-ee+3c/70X5fNO+IApwy53GkPzvjW+qLbwpZ5qo9ofYU=";
        };
      };

      tabby = pkgs.stdenv.mkDerivation {
        pname = "tabby";
        inherit version;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        dontUnpack = true;
        installPhase = ''
          bin="$(find ${appimage}/bin -maxdepth 1 -type f | head -n 1)"
          makeWrapper "$bin" "$out/bin/tabby" --add-flags "--no-sandbox"
        '';
        meta = {
          description = "Terminal emulator and SSH/SFTP client";
          homepage = "https://github.com/Eugeny/tabby";
          license = pkgs.lib.licenses.mit;
          mainProgram = "tabby";
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
        };
      };
    in
    {
      packages.${system} = {
        inherit tabby;
        default = tabby;
      };
    };
}
