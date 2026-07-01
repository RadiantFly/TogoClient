#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR/apps/desktop"

if [ ! -f ".env" ] && [ -f ".env.example" ]; then
  cp .env.example .env
fi

npm install
npm run tauri dev
