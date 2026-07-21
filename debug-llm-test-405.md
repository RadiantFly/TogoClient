# [OPEN] LLM Test 405

## Session

- session_id: `llm-test-405`
- created_at: `2026-07-01`
- scope: `http://127.0.0.1:8080/config/llm_services/test.json` 返回 `405 Method Not Allowed`

## Symptom

- 请求 URL：`http://127.0.0.1:8080/config/llm_services/test.json`
- 错误信息：`405 Method Not Allowed`

## Initial Hypotheses

1. 该接口仅允许 `POST`，当前请求方法是 `GET`，因此被 controller 拒绝。
2. 路由配置存在，但 controller 只实现了特定 HTTP verb，没有实现当前请求方法。
3. 前端或桌面端调用封装把“测试 LLM 服务”的请求错误地发成了 `GET`。
4. 存在相似但不同的正确接口路径，当前命中的只是一个不支持该方法的路由。

## Plan

1. 读取路由与对应 controller，确认该接口声明的 HTTP method。
2. 用命令直接复现 `GET` / `POST` 请求，拿到运行时证据。
3. 根据证据确认是接口设计如此，还是前端调用有误。
4. 如需修改代码，先加最小埋点，再进行修复与验证。

## Evidence

- 直接请求 `GET http://127.0.0.1:8080/config/llm_services/test.json`，后端返回 `404 Not Found`。
- `external/TogoSpace/src/route.py` 中真实路由是 `POST /config/llm_test.json`，对应 `settingController.LlmTestHandler`。
- `external/TogoSpace/src/controller/settingController.py` 显示 `LlmTestHandler` 仅实现了 `post()`，且请求体要求：
  - `provider: dict`
  - `model: dict`
  - `protocol?: string`
- `apps/desktop/src/api.ts` 中桌面端仍在请求旧地址 `/config/llm_services/test.json`，并发送旧格式 payload。

## Conclusion

- Hypothesis 1（接口只允许 POST）: 成立。
- Hypothesis 2（路由存在但 method 不匹配）: 成立，但更准确地说，桌面端命中的还是旧版路径。
- Hypothesis 3（前端调用方法或地址错误）: 成立。
- Hypothesis 4（存在不同正确路径）: 成立，正确路径是 `/config/llm_test.json`。

## Fix

- 将桌面端 `testLlmService()` 的请求地址从 `/config/llm_services/test.json` 改为 `/config/llm_test.json`。
- 将旧的扁平 payload 映射为后端当前要求的 `{ provider, model, protocol }` 结构。

## Verification

- 修复后，向 `POST /config/llm_test.json` 发送结构化请求，后端返回 `HTTP 200`。
- 返回体从原先的路由/方法错误，变为业务层测试结果：
  - `status: "error"`
  - `raw_error: "OpenAIException - Connection error."`
- 这说明接口层已经打通，当前剩余问题仅是上游 LLM 地址连通性，而不是 405 / 路由错误。
