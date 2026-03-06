#!/usr/bin/env bash
set -euo pipefail

echo "Building obamify... this takes a while the first time"
docker compose up --build -d

echo "Waiting for container to become healthy..."
until [ "$(docker inspect --format='{{.State.Health.Status}}' "$(docker compose ps -q obamify)")" = "healthy" ]; do
    sleep 2
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  👉  Open this in your browser:"
echo ""
echo "       http://localhost:8080"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  To stop:  docker compose down"
