#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# نسخة الويب للإدمن — المحتوى جاهز للرفع من مجلد build/web_admin
flutter build web -t lib/main_admin.dart --release -o build/web_admin

find build/web_admin -type d -exec chmod 755 {} +
find build/web_admin -type f -exec chmod 644 {} +

echo "Done. Upload folder: $(pwd)/build/web_admin"
