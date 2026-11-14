# tabby-flake

[Tabby](https://github.com/Eugeny/tabby) 终端的 Nix flake 打包，基于官方 Linux x86_64 AppImage。

## 使用

```nix
inputs.tabby-flake.url = "github:dvduzu/tabby-flake";
inputs.tabby-flake.inputs.nixpkgs.follows = "nixpkgs";
```

```nix
home.packages = [
  inputs.tabby-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

## 说明

- 通过 `appimageTools.wrapType2` 解包官方 AppImage，并用 FHS 环境运行。
- 启动时附加 `--no-sandbox`，避免 Electron 在 NixOS 上因 SUID sandbox 缺失而无法启动。
- `.github/workflows/check-upstream.yml` 每天检查上游 release，自动更新 `flake.nix` 中的版本与 sha256，并构建验证后提交。
- `.github/workflows/nix-build.yml` 在每次推送和 PR 时构建验证。

## 手动构建

```sh
nix build .#default
./result/bin/tabby
```
