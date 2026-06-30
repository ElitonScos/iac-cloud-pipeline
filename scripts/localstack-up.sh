#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

docker compose up -d localstack

echo "Waiting for LocalStack to become healthy..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:4566/_localstack/health >/dev/null 2>&1; then
    echo "LocalStack ready at http://localhost:4566"
    curl -s http://localhost:4566/_localstack/health
    exit 0
  fi
  sleep 2
done

echo "LocalStack did not respond in time." >&2
exit 1
