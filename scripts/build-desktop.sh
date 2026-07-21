#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/desktop"

cd "$APP_DIR"

if [ ! -f ".env" ] && [ -f ".env.example" ]; then
  cp .env.example .env
fi

# Avoid stale absolute paths inside Tauri build artifacts after moving the repo.
if [ -d "src-tauri/target" ]; then
  rm -rf "src-tauri/target"
fi

npm install
PATH="$HOME/.cargo/bin:$PATH" npm run tauri build -- --bundles app,dmg

echo
echo "Build outputs:"
echo "  $APP_DIR/src-tauri/target/release/bundle/macos/TogoClient.app"
echo "  $APP_DIR/src-tauri/target/release/bundle/dmg/TogoClient_0.2.0_aarch64.dmg"
