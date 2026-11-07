## BambuStudio 02.09.01.70 for Termux

首个可用的 bionic/aarch64 原生版本。

### 安装

```bash
curl -fsSL https://raw.githubusercontent.com/xiaoxiaoyu-miao/bambu-studio-termux/main/install.sh | bash
```

或手动：

```bash
pkg install x11-repo tur-repo
pkg update
pkg install ./bambu-studio_02.09.01.70_aarch64.deb
```

### 本次内容

- BambuStudio 02.09.01.70（bionic / aarch64，无 proot / glibc）
- 中文界面
- GPU 加速：Mesa 26 + virgl → zink → turnip → Adreno
- open-bamboo-networking 插件（网络/登录/局域网）
- 一键启动器 `bambu-studio`
- 完整运行时依赖（126 个包）写入 Depends，`pkg install` 自动安装

### 资产

| 文件 | 说明 |
|---|---|
| `bambu-studio_02.09.01.70_aarch64.deb` | 安装包 |
| `install.sh` | 一键安装脚本 |
| `SHA256SUMS` | 校验文件 |

### 要求

- Termux（aarch64）+ Termux:X11 应用
- `x11-repo`、TUR 仓库
- 约 1.2 GB 磁盘空间

### 已知问题

- MSAA 必须设为 `Disabled`（zink 下 X4 可能崩溃）
- 在线模型页面可能被 Cloudflare 拦截
- mesa 27.x 如异常，可 `apt-mark hold mesa mesa-vulkan-icd-freedreno`
