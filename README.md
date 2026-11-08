# BambuStudio for Termux

在 **Termux（bionic / aarch64）** 上原生运行的 BambuStudio 02.09.01.70。
不使用 proot / glibc，已内置：

- 完整中文界面
- GPU 加速（Mesa 26 + virgl → zink → turnip → Adreno）
- open-bamboo-networking 网络插件（登录、云端、局域网）
- 一键启动器：自动拉起 `am` / termux-x11 / icewm / virgl / Studio

## 一行安装

```bash
curl -fsSL https://raw.githubusercontent.com/xiaoxiaoyu-miao/bambu-studio-termux/main/install.sh | bash
```

脚本会自动启用 `x11-repo` 和 TUR 仓库、安装依赖、下载并安装 deb。

## 手动安装

```bash
pkg install x11-repo tur-repo
pkg update
pkg install mesa mesa-vulkan-icd-freedreno virglrenderer-android \
            termux-x11-nightly icewm dbus xorg-xrandr termux-am

curl -LO https://github.com/xiaoxiaoyu-miao/bambu-studio-termux/releases/download/v02.09.01.70/bambu-studio_02.09.01.70_aarch64.deb
pkg install ./bambu-studio_02.09.01.70_aarch64.deb
```

> 必须用 `pkg install ./xxx.deb`（apt 会解析依赖）；`dpkg -i` 不会装依赖。

## 启动

```bash
bambu-studio
```

首次启动会自动：

1. `am start` 打开 Termux:X11
2. 若 `:0` 没有 X 服务，启动 `termux-x11` + icewm
3. 启动 `virgl_test_server_android`
4. 设置 `GALLIUM_DRIVER=virpipe`
5. 部署网络插件（首次）
6. 启动 Studio

## 环境要求

- Android aarch64 设备，建议 8GB+ RAM
- Termux（GitHub 版或 F-Droid 版均可）
- **Termux:X11** Android 应用
- 已启用 `x11-repo` 与 TUR 仓库（脚本会自动处理）
- 磁盘空间：安装后约 1.2 GB（含资源）

## 图形加速说明

| 组件 | 版本/来源 |
|---|---|
| Mesa | `mesa` 26.2.6+（DRI/EGL/GLX） |
| Vulkan | `mesa-vulkan-icd-freedreno`（turnip） |
| 传输 | `virglrenderer-android` + `GALLIUM_DRIVER=virpipe` |
| 实际渲染 | zink → Vulkan → turnip → KGSL → Adreno |

日志里应出现：

```
opengl detected ... gpu="zink Vulkan 1.4(Adreno (TM) 8xx (MESA_TURNIP))"
```

## 已知事项

- 启动器已自动设置 `MESA_VK_WSI_DEBUG=sw`，修复
  `CreateSwapchainKHR failed` / `zink: could not create swapchain`。

- **MSAA**：`~/.config/BambuStudioInternal/BambuStudio.conf` 中
  `"msaa_type"` 必须是 `"Disabled"`，否则 zink 渲染缩略图可能崩溃。
- 在线模型/MakerWorld 页面可能被 Cloudflare 拦截，与客户端无关。
- 若系统把 `mesa` 升级到 27.x 后出现异常，可回退并锁定：
  ```bash
  apt-mark hold mesa mesa-vulkan-icd-freedreno
  ```
- 重新安装/升级本包不会覆盖用户配置。

## 卸载

```bash
pkg uninstall bambu-studio
rm -rf ~/.config/BambuStudioInternal
```
（插件与配置都在用户目录，卸载包不会自动删除。）

## 许可

BambuStudio 本体为 **AGPL-3.0**；本仓库仅包含安装脚本与打包产物说明。
内置的 Bambu 官方配置/资源遵循其各自许可。
