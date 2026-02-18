#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PW_DIR="$SCRIPT_DIR/../packages/pw-test-writer"

echo "Building pw-test-writer..."
(cd "$PW_DIR" && npm run build)

echo "Bundling MCP server..."
npx esbuild "$PW_DIR/dist/mcp-server.js" \
  --bundle \
  --platform=node \
  --target=node20 \
  --format=esm \
  --outfile="$SCRIPT_DIR/server/mcp-server.js" \
  --banner:js='import { createRequire } from "module"; const require = createRequire(import.meta.url);'

echo "Copying capture hook..."
cp "$PW_DIR/src/runner/captureHook.cjs" "$SCRIPT_DIR/runner/captureHook.cjs"

echo "Done. Plugin ready at: $SCRIPT_DIR"
