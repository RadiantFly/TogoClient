#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT_DIR"

if [ -d "external/TogoSpace/.git" ] || [ -f ".gitmodules" ]; then
  echo "TogoSpace submodule appears to be configured already."
  exit 0
fi

git submodule add https://github.com/alexazhou/TogoAgent.git external/TogoSpace
git submodule update --init --recursive

echo "TogoSpace submodule is ready at external/TogoSpace"
