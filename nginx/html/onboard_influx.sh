#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://influxdb.hauthanhhuyen.com}"

# Thông tin onboarding
USERNAME="${USERNAME:-admin}"
PASSWORD="${PASSWORD:-Admin123456}"
ORG="${ORG:-Huyen}"
BUCKET="${BUCKET:-iot}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
RETENTION_SEC=$((RETENTION_DAYS*24*3600))

echo "[i] Kiểm tra trạng thái setup..."
ALLOWED=$(curl -sf "${BASE_URL}/api/v2/setup" | jq -r '.allowed // empty')
if [[ "$ALLOWED" == "false" ]]; then
  echo "[!] Instance đã setup rồi. Dùng script create_influx_resources.sh (Trường hợp B)."
  exit 1
fi

echo "[i] Thực hiện onboarding..."
RESP=$(curl -sf -X POST "${BASE_URL}/api/v2/setup" \
  -H 'Content-Type: application/json' \
  -d "$(jq -n \
      --arg u "$USERNAME" \
      --arg p "$PASSWORD" \
      --arg o "$ORG" \
      --arg b "$BUCKET" \
      --argjson r "$RETENTION_SEC" \
      '{username:$u,password:$p,org:$o,bucket:$b,retentionPeriodSeconds:$r}')")

TOKEN=$(jq -r '.auth.token' <<<"$RESP")
ORG_ID=$(jq -r '.org.id' <<<"$RESP")
BUCKET_ID=$(jq -r '.bucket.id' <<<"$RESP")

echo "[OK] Onboarding xong:"
echo "  USERNAME=$USERNAME"
echo "  ORG=$ORG (id=$ORG_ID)"
echo "  BUCKET=$BUCKET (id=$BUCKET_ID, retention=${RETENTION_DAYS}d)"
echo "  TOKEN=$TOKEN"

# Lưu ra file .env để dùng cho Node-RED/Grafana
cat > .env.influx <<EOF
INFLUX_BASE_URL=$BASE_URL
INFLUX_ORG=$ORG
INFLUX_BUCKET=$BUCKET
INFLUX_TOKEN=$TOKEN
EOF
echo "[i] Đã lưu token vào .env.influx"
