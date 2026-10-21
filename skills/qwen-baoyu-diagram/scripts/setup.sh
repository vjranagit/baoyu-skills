#!/usr/bin/env bash
set -euo pipefail
skill_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$skill_dir"
command -v node >/dev/null || { echo 'Node.js is required.' >&2; exit 1; }
npm install --no-audit --no-fund
npm exec --yes --package=bun -- bun --version >/dev/null
echo 'qwen-baoyu-diagram dependencies ready.'
