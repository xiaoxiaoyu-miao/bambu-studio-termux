#!/data/data/com.termux/files/usr/bin/bash
# BambuStudio for Termux 一键安装脚本
# 用法：curl -fsSL https://raw.githubusercontent.com/xiaoxiaoyu-miao/bambu-studio-termux/main/install.sh | bash
set -euo pipefail

REPO="xiaoxiaoyu-miao/bambu-studio-termux"
VER="02.09.01.70"
DEB="bambu-studio_${VER}_aarch64.deb"
BASE="https://github.com/${REPO}/releases/download/v${VER}"
TMP="${TMPDIR:-${PREFIX:-/data/data/com.termux/files/usr}/tmp}/bambu-install"

say() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[ -n "${PREFIX:-}" ] || die "请在 Termux 中运行"
[ "$(uname -m)" = "aarch64" ] || die "仅支持 aarch64 Termux"

say "启用 x11-repo 与 TUR 仓库"
pkg install -y x11-repo tur-repo
pkg update -y

say "安装图形加速与桌面依赖"
pkg install -y mesa mesa-vulkan-icd-freedreno virglrenderer-android \
               termux-x11-nightly icewm dbus xorg-xrandr termux-am

mkdir -p "$TMP"
say "下载 ${DEB}（约 234 MB）"
curl -fL --retry 3 --retry-delay 2 -o "$TMP/$DEB" "$BASE/$DEB" \
  || die "下载失败：$BASE/$DEB"

if curl -fsSL -o "$TMP/SHA256SUMS" "$BASE/SHA256SUMS" 2>/dev/null; then
    say "校验 SHA256"
    ( cd "$TMP" && sed "s#dist/##" SHA256SUMS | sha256sum -c - ) \
      || die "SHA256 校验失败"
fi

say "安装 BambuStudio"
pkg install -y "$TMP/$DEB"

rm -rf "$TMP"

cat <<'EOF'

安装完成。

  启动：  bambu-studio
  首次启动会自动：启动 virgl、termux-x11 + icewm、部署网络插件。

提示：
  - 需要先安装 Termux:X11 的 Android 应用
  - 首次运行若 3D 视图异常，确认配置里 msaa_type 为 "Disabled"
  - 中文界面已内置
EOF
