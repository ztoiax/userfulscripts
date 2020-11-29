#!/bin/sh

# from https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks
# 列出第三方程序使用一般方式安装 (例如 ./configure; make; make install) 的文件、配置文件、日志等

tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
db=$tmp/db
fs=$tmp/fs

mkdir "$tmp"
trap  'rm -rf "$tmp"' EXIT

pacman -Qlq | sort -u > "$db"

find /bin /etc /lib /sbin /usr \
  ! -name lost+found \
  \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

comm -23 "$fs" "$db"
