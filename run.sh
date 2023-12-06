#!/bin/bash
set -xue

# QEMUのファイルパス
QEMU=qemu-system-riscv32

# clangのパス (Ubuntuの場合は CC=clang)
CC=/opt/homebrew/opt/llvm/bin/clang

# -std=c11: C11を使用する。
# -O2: 最適化を有効にして、効率の良い機械語を生成する。
# -g3: デバッグ情報を最大限に出力する。
# -Wall: 主要な警告を有効にする。
# -Wextra: さらに追加の警告を有効にする。
# --target=riscv32: 32ビットRISC-V用にコンパイルする。
# -ffreestanding: ホスト環境 (開発環境) の標準ライブラリを使用しない。
# -nostdlib: 標準ライブラリをリンクしない。
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32 -ffreestanding -nostdlib"

# カーネルをビルド
# -Wl,-Tkernel.ld: リンカスクリプトを指定する。
# -Wl,-Map=kernel.map: マップファイル (リンカーによる配置結果) を出力する。
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    kernel.c

# QEMUを起動
# -machin virt: virtマシンとして起動する
# -bios default: デフォルトのBIOS(OpenSBI)を使用する
# -nographic: グラフィックなしで起動する
# -serial mon:stdio: QEMUの標準入出力を仮想マシンのシリアルポートに接続する
# --no-reboot: 仮想マシンがクラッシュしたら、再起動せずに停止させる（デバッグに便利）
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot
