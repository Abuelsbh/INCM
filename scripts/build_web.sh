#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# الموقع العام (lib/main.dart) — ليس نسخة الإدمن. المخرجات: build/web
# يمكن تجاوز أي قيمة عبر متغيرات البيئة قبل التشغيل (اختياري).
: "${EMAILJS_PUBLIC_KEY:=c2CINDnIoCrUUP5__}"
: "${EMAILJS_SERVICE_ID:=service_42dy7lk}"
: "${EMAILJS_TEMPLATE_ID:=template_bjbjbrd}"
: "${RECIPIENT_EMAIL:=abuelsbh.mahmoud@gmail.com}"
: "${EMAILJS_ACCESS_TOKEN:=}"

flutter build web -t lib/main.dart --release -o build/web \
  --dart-define=EMAILJS_PUBLIC_KEY="${EMAILJS_PUBLIC_KEY}" \
  --dart-define=EMAILJS_SERVICE_ID="${EMAILJS_SERVICE_ID}" \
  --dart-define=EMAILJS_TEMPLATE_ID="${EMAILJS_TEMPLATE_ID}" \
  --dart-define=RECIPIENT_EMAIL="${RECIPIENT_EMAIL}" \
  --dart-define=EMAILJS_ACCESS_TOKEN="${EMAILJS_ACCESS_TOKEN}"

echo "Done. Upload folder: $(pwd)/build/web"
