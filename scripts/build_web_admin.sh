#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# نسخة الويب للإدمن — المحتوى جاهز للرفع من مجلد build/web_admin
flutter build web -t lib/main_admin.dart --release -o build/web_admin
echo "Done. Upload folder: $(pwd)/build/web_admin"
