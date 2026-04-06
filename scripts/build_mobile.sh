#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# نفس قيم build_web.sh — اختياري للموبايل؛ Firestore/الأدمن هو المصدر الأساسي بعد التعديلات الأخيرة.
# الاستخدام: ./scripts/build_mobile.sh apk   أو   ./scripts/build_mobile.sh ios
: "${EMAILJS_PUBLIC_KEY:=c2CINDnIoCrUUP5__}"
: "${EMAILJS_SERVICE_ID:=service_42dy7lk}"
: "${EMAILJS_TEMPLATE_ID:=template_bjbjbrd}"
: "${RECIPIENT_EMAIL:=abuelsbh.mahmoud@gmail.com}"
: "${EMAILJS_ACCESS_TOKEN:=}"

defines=(
  "--dart-define=EMAILJS_PUBLIC_KEY=${EMAILJS_PUBLIC_KEY}"
  "--dart-define=EMAILJS_SERVICE_ID=${EMAILJS_SERVICE_ID}"
  "--dart-define=EMAILJS_TEMPLATE_ID=${EMAILJS_TEMPLATE_ID}"
  "--dart-define=RECIPIENT_EMAIL=${RECIPIENT_EMAIL}"
  "--dart-define=EMAILJS_ACCESS_TOKEN=${EMAILJS_ACCESS_TOKEN}"
)

target="${1:-apk}"

case "$target" in
  apk)
    flutter build apk -t lib/main.dart --release "${defines[@]}"
    ;;
  appbundle)
    flutter build appbundle -t lib/main.dart --release "${defines[@]}"
    ;;
  ios)
    flutter build ios -t lib/main.dart --release "${defines[@]}"
    ;;
  *)
    echo "Usage: $0 [apk|appbundle|ios]" >&2
    exit 1
    ;;
esac
