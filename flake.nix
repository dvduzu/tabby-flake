{
  description = "Tabby 终端（Eugeny/tabby）的 Nix flake 打包";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };

      tabby = pkgs.callPackage ./packages/tabby.nix { };
    in
    {
      packages.${system} = {
        inherit tabby;
        default = tabby;
      };

      homeModules.default =
        { ... }:
        {
          home.packages = [ tabby ];
        };
    };
}
