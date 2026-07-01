# TogoClient Desktop

This directory contains the current desktop client for `TogoClient`.

## Stack

- `Tauri 2`
- `Vue 3`
- `TypeScript`
- `Vue Router`
- `Vue I18n`
- `Vite`

## Current scope

The current implementation targets parity with `/Volumes/Extend/git/TogoSpace/frontend`
and adds desktop-only capabilities on top:

- console chat and task views
- settings sections for teams, roles, models, skills, and maintenance
- real-time room, agent, and task updates over WebSocket
- Tauri tray menu, close-to-tray behavior, and macOS notifications
- one-click start / stop for the local `TogoSpace` backend
- top-bar desktop status button with red / green connectivity indicator
- drag-and-drop file paths into the chat composer
- clickable local paths in chat with subtle path chips, Finder reveal, and copy actions
- packaged macOS app and DMG with the husky app icon

## Local development

1. Copy `.env.example` to `.env`
2. Set `VITE_API_BASE_URL` if you need a non-default backend address
3. Optionally set `TOGOSPACE_ROOT` if the local backend repo is not located at `external/TogoSpace`
3. Install dependencies:

```bash
npm install
```

4. Start the desktop app:

```bash
npm run tauri dev
```

## Build

If `cargo` is not already available on the machine, install Rust with the
`rsproxy.cn` mirror first:

```bash
RUSTUP_DIST_SERVER=https://rsproxy.cn \
RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup \
curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -y
```

Then build the macOS app bundle and DMG:

```bash
PATH="$HOME/.cargo/bin:$PATH" npm run tauri build
```

Current build outputs:

- `src-tauri/target/release/bundle/macos/TogoClient.app`
- `src-tauri/target/release/bundle/dmg/TogoClient_0.2.0_aarch64.dmg`

## Notes

- The desktop app defaults to `http://127.0.0.1:8080`.
- If `TOGOSPACE_ROOT` is not set, the app will try `external/TogoSpace` and common sibling paths.
- In packaged desktop mode, API requests go through a native Tauri HTTP bridge so the app can talk to the local backend without modifying `external/TogoSpace` CORS behavior.
- In packaged desktop mode, real-time events use a native Tauri bridge to avoid macOS WebView WebSocket origin restrictions.
- JSON write requests use a no-preflight content type so they can talk to the local Tornado backend without changing `external/TogoSpace`.
- The tray menu can show the main window, start or stop the backend, open the local `TogoSpace` directory, and quit.
- The in-app desktop status button hides backend controls behind a compact menu and shows a red / green badge for backend connectivity.
- Dropping files into the composer inserts absolute paths when the runtime exposes them, and falls back to file names otherwise.
- Local absolute paths rendered in chat, including inline-code paths, are recognized by regex or inline path detection, wrapped in subtle path chips, and provide Finder reveal plus copy actions on macOS desktop builds.
- Project-local cargo mirror config lives in `.cargo/config.toml`.
