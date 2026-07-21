# [OPEN] Startup API Upgrade

## 问题描述

- 现象：`TogoSpace` 升级后，`TogoClient2` 启动失败，怀疑与接口替换或模型识别相关。
- 当前状态：待收集运行时证据与接口兼容性差异。

## 会话信息

- sessionId: `startup-api-upgrade`
- 日期: `2026-07-21`

## 初始假设

1. 启动阶段调用的某个 HTTP 接口路径已变更，客户端仍请求旧路径，导致初始化失败。
2. 接口返回字段结构变更，前端或桌面端启动时解析模型列表/默认模型配置时报错。
3. `WebSocket` 或启动健康检查接口协议变更，客户端把服务判定为未启动。
4. `TogoSpace` 升级后鉴权参数或请求头要求变化，初始化请求被拒绝。
5. 桌面端本地“启动后端”脚本仍假设旧的启动参数或旧目录结构，实际并未成功拉起新版本服务。

## 计划

1. 定位启动入口、服务探测、模型初始化相关代码。
2. 复现失败并抓取终端/前端日志。
3. 先添加最小化调试埋点，确认失败发生在哪个接口或阶段。
4. 基于证据做最小修复并复验。

## 运行时证据

- `external/TogoSpace/logs/backend_stdout.log` 已出现新后端对旧接口的拒绝记录：
  - `404 GET /config/llm_services/list.json`
  - `405 POST /config/llm_services/test.json`
  - `405 POST /config/llm_services/create.json`
- 当前本机直接请求验证一致：
  - `GET /config/llm_services/list.json` 返回 `404`
  - `GET /config/llm.json` 返回 `200`，并且数据结构为 `llm_providers + default_models + context_config`
- `GET /config/frontend.json` 的服务端实现也已经切到 `model_slots`，不再直接返回旧的 `models/default_model` 结构。

## 结论

1. 根因不是“模型本身失效”，而是桌面端仍消费旧的模型配置协议。
2. 受影响链路包括：
   - 设置页模型列表与模型增删改默认模型
   - 快速初始化 `quick_init`
   - 团队成员模型下拉的数据适配
3. 启动期相关的模型识别问题，本质上也是新旧配置结构不兼容导致的字段识别失败。

## 已实施修复

- 在 `apps/desktop/src/api.ts` 增加兼容层：
  - 读取 `/config/llm.json`，映射回桌面端既有 `LlmServiceInfo`
  - 将旧的“按 index 增删改默认模型”操作翻译成对 `llm.json` 的整包读改写
  - `getFrontendConfig()` 改为组合 `frontend.json + llm.json`，恢复模型列表与默认模型识别
  - `quickInit()` 适配新字段 `extra_params`
- 在桌面端类型和 UI 常量中补充新 provider 类型识别：
  - `openai`
  - `aliyun`
  - `other`

## 验证

- `apps/desktop` 已执行 `npm run build`
- 构建通过，说明 TypeScript 类型与前端编译链路已恢复
- 由于浏览器沙箱无法直接访问本机 `127.0.0.1:8080`，未在浏览器预览中完成完整接口联调；接口级验证已通过 `curl` 完成
