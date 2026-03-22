#!/bin/bash
set -e

SLUICE="http://localhost:8080"

echo "=== Health check ==="
curl -s "$SLUICE/healthz" | jq .

echo ""
echo "=== Publish to user-events (with ordering key) ==="
curl -s -X POST "$SLUICE/v1/publish/user-events" \
  -H "x-user-id: user-42" \
  -d '{"user_id": "user-42", "event_type": "login", "timestamp": "2026-03-22T10:00:00Z"}' | jq .

echo ""
echo "=== Publish to page-views ==="
curl -s -X POST "$SLUICE/v1/publish/page-views" \
  -d '{"url": "/products/123", "session_id": "sess-abc", "timestamp": "2026-03-22T10:00:01Z"}' | jq .

echo ""
echo "=== Publish to system-metrics (no validation) ==="
curl -s -X POST "$SLUICE/v1/publish/system-metrics" \
  -d '{"cpu": 42.5, "memory": 1024}' | jq .

echo ""
echo "=== Publish with missing required field (should fail with 400) ==="
curl -s -w "\nHTTP %{http_code}\n" -X POST "$SLUICE/v1/publish/user-events" \
  -H "x-user-id: user-42" \
  -d '{"user_id": "user-42"}'

echo ""
echo "=== Publish to unknown topic (should fail with 404) ==="
curl -s -w "\nHTTP %{http_code}\n" -X POST "$SLUICE/v1/publish/nonexistent" \
  -d '{"test": true}'
