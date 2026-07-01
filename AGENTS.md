# TogoClient
由于web被浏览器限制，导致功能无法实现，做一个Togo的客户端，方便有更好的操作

## 当前方向

`TogoClient` 当前定位为 `Tauri` 桌面客户端工程。

- 目标：为 `TogoSpace` 提供桌面端入口
- 方式：以子仓库方式引入 `TogoSpace`
- 范围：当前以 `/Volumes/Extend/git/TogoSpace/frontend` 为主要功能基线，并叠加桌面端能力

## 当前进度

已完成首版桌面端工程骨架：

- `external/TogoSpace`：已接入的 `git submodule`
- `apps/desktop`：`Tauri + Vue 3 + TypeScript + Vue Router + Vue I18n` 工程
- `scripts/setup-togospace-submodule.sh`：初始化 `TogoSpace` 子仓库脚本
- `scripts/dev-desktop.sh`：本地开发启动脚本

当前已落地的界面与能力：

- 对齐 `TogoSpace/frontend` 的控制台和设置页结构
- 房间、消息、Agent、任务、团队设置等主要页面能力
- `TogoSpace` HTTP 接口接入
- `WebSocket` 实时事件接入
- 托盘菜单、关闭到托盘、系统通知
- 一键启动/停止本地 `TogoSpace` 后端
- 哈士奇应用图标与 `0.2.0` 版 macOS `.app` / `.dmg` 打包产物

## 开发启动

```bash
./scripts/setup-togospace-submodule.sh
./scripts/dev-desktop.sh
```

## 文档

- [文档索引](./docs/README.md)
- [Tauri 客户端方案](./docs/tauri-client-spec.md)
- [Tauri 客户端检查清单](./docs/tauri-client-checklist.md)
- [Tauri 客户端任务拆解](./docs/tauri-client-tasks.md)
- [桌面端 README](./apps/desktop/README.md)
