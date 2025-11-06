#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://influxdb.hauthanhhuyen.com}"
ADMIN_TOKEN="${ADMIN_TOKEN:?Đặt biến môi trường ADMIN_TOKEN là token có quyền admin/org}"
ORG="${ORG:-Huyen}"
BUCKET="${BUCKET:-iot}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
RETENTION_SEC=$((RETENTION_DAYS*24*3600))

HDR=(-H "Authorization: Token ${ADMIN_TOKEN}" -H "Content-Type: application/json")

echo "[i] Tìm Org '$ORG'..."
ORG_JSON=$(curl -sf "${BASE_URL}/api/v2/orgs?org=$(printf %s "$ORG")" -H "Authorization: Token ${ADMIN_TOKEN}")
ORG_ID=$(jq -r '.orgs[0].id // empty' <<<"$ORG_JSON")
if [[ -z "$ORG_ID" ]]; then
  echo "[i] Chưa có Org. Tạo mới..."
  ORG_JSON=$(curl -sf -X POST "${BASE_URL}/api/v2/orgs" "${HDR[@]}" \
    -d "$(jq -n --arg name "$ORG" '{name:$name}')")
  ORG_ID=$(jq -r '.id' <<<"$ORG_JSON")
fi
echo "[OK] ORG_ID=$ORG_ID"

echo "[i] Tìm Bucket '$BUCKET'..."
BKT_JSON=$(curl -sf "${BASE_URL}/api/v2/buckets?name=$(printf %s "$BUCKET")&orgID=${ORG_ID}" -H "Authorization: Token ${ADMIN_TOKEN}")
BUCKET_ID=$(jq -r '.buckets[0].id // empty' <<<"$BKT_JSON")
if [[ -z "$BUCKET_ID" ]]; then
  echo "[i] Chưa có Bucket. Tạo mới..."
  BKT_JSON=$(curl -sf -X POST "${BASE_URL}/api/v2/buckets" "${HDR[@]}" \
    -d "$(jq -n \
      --arg name "$BUCKET" \
      --arg orgID "$ORG_ID" \
      --argjson every "$RETENTION_SEC" \
      '{name:$name, orgID:$orgID, retentionRules:[{type:"expire", everySeconds:$every}]}')")
  BUCKET_ID=$(jq -r '.id' <<<"$BKT_JSON")
fi
echo "[OK] BUCKET_ID=$BUCKET_ID (retention ${RETENTION_DAYS}d)"

echo "[i] Tạo token scoped cho bucket (read/write)..."
AUTH_JSON=$(curl -sf -X POST "${BASE_URL}/api/v2/authorizations" "${HDR[@]}" \
  -d "$(jq -n \
    --arg orgID "$ORG_ID" \
    --arg bktID "$BUCKET_ID" \
    --arg desc "token for ${ORG}/${BUCKET}" \
    '{orgID:$orgID, description:$desc,
      permissions:[
        {action:"read",  resource:{type:"buckets", id:$bktID}},
        {action:"write", resource:{type:"buckets", id:$bktID}}
      ]}')")
TOKEN=$(jq -r '.token' <<<"$AUTH_JSON")

echo "[OK] TOKEN=$TOKEN"

cat > .env.influx <<EON
INFLUX_BASE_URL=$BASE_URL
INFLUX_ORG=$ORG
INFLUX_BUCKET=$BUCKET
INFLUX_TOKEN=$TOKEN
EON
echo "[i] Đã lưu token vào .env.influx"
