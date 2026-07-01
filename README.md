# TogoClient

`TogoClient` 是一个面向 `TogoSpace` 的桌面客户端工程。

项目目标是基于 `Tauri` 提供一个比浏览器环境更适合桌面操作的客户端入口，在尽量保持 `TogoSpace` 原有控制台能力的基础上，补上浏览器环境受限时难以实现的桌面能力。

上游项目：

- `TogoSpace`：<https://github.com/alexazhou/TogoSpace>

## 项目定位

当前仓库的职责不是重写一套新的后端，而是：

- 以 `git submodule` 方式接入 `TogoSpace`
- 复用 `TogoSpace` 后端能力，在桌面端独立实现客户端交互
- 在桌面端补充系统级能力和更顺手的本地操作体验

当前桌面端工程位于：

- `external/TogoSpace`：上游子模块
- `apps/desktop`：`Tauri + Vue 3 + TypeScript` 桌面客户端

## 已实现能力

目前已经落地的内容包括：

- 对齐 `TogoSpace` 控制台和设置页的主要结构
- 房间、消息、Agent、任务、团队设置等核心页面
- 接入 `TogoSpace` 的 HTTP 接口和 WebSocket 实时事件
- 托盘菜单、关闭到托盘、系统通知
- 一键启动和停止本地 `TogoSpace` 后端
- 拖入文件后将本地文件转为聊天输入中的路径
- 聊天消息中的本地路径支持点击打开、在 Finder 中定位和复制
- macOS 桌面端打包产物与应用图标

## 为什么要做桌面端

浏览器环境在以下场景存在天然限制：

- 本地文件路径交互不够顺手
- 调起系统能力受限
- 托盘、通知、窗口管理等桌面行为支持有限
- 某些本地网络访问和实时连接场景需要额外兼容处理

因此这个仓库的重点，是在不侵入 `TogoSpace` 主体能力的前提下，为其提供更自然的桌面使用体验。

## 快速开始

### 1. 初始化子模块

```bash
./scripts/setup-togospace-submodule.sh
```

### 2. 启动桌面端开发环境

```bash
./scripts/dev-desktop.sh
```

如果你希望单独进入桌面端目录开发，也可以参考：

```bash
cd apps/desktop
cp .env.example .env
npm install
npm run tauri dev
```

## 目录说明

```text
TogoClient/
├── external/TogoSpace   # 上游 TogoSpace 子模块
├── apps/desktop         # Tauri 桌面客户端
├── docs/                # 方案、清单、任务拆解等文档
└── scripts/             # 子模块初始化与本地开发脚本
```

## 文档入口

- [文档索引](./docs/README.md)
- [Tauri 客户端方案](./docs/tauri-client-spec.md)
- [Tauri 客户端检查清单](./docs/tauri-client-checklist.md)
- [Tauri 客户端任务拆解](./docs/tauri-client-tasks.md)
- [桌面端 README](./apps/desktop/README.md)

## 当前状态

当前仓库已经完成首版桌面端工程骨架，并已具备日常开发和基础打包能力。

后续工作重点仍然会放在：

- 持续补齐与 `TogoSpace` 的能力对齐
- 优化桌面端专属交互
- 提升本地启动、连接状态和文件操作体验
