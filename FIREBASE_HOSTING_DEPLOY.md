# نشر الموقع على Firebase Hosting

## الإعداد (تم بالفعل ✓)

تم إنشاء الملفات التالية:
- `firebase.json` - إعدادات Hosting (يشير إلى `build/web`)
- `.firebaserc` - معرف المشروع (حالياً: incm-c87aa)

---

## خطوات النشر

### 1. تسجيل الدخول (إن لم تكن مسجلاً)
```bash
firebase login
```

### 2. ربط المشروع الصحيح

**إذا كان مشروع incm-c87aa موجود ولديك صلاحية:**
```bash
firebase use incm-c87aa
```

**إذا أردت استخدام مشروع آخر من قائمتك:**
```bash
firebase use <project-id>
# مثال: firebase use adel-ride
```

**إذا أردت إنشاء مشروع جديد:**
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اضغط "Add project" أو "إضافة مشروع"
3. اختر اسم المشروع واحفظ الـ Project ID
4. عدّل `.firebaserc` وضع الـ Project ID الجديد
5. أو نفّذ: `firebase use <project-id>`

### 3. بناء تطبيق الويب
```bash
./scripts/build_web.sh
```

**مهم:** لا ترفع `build/web` قبل تصحيح صلاحيات الملفات. بعض صور `assets/` كانت `600` فيُرفضها Apache/cPanel بـ **403** ولا تظهر على الموقع. السكربت أعلاه يضبط `644` للملفات و`755` للمجلدات تلقائياً بعد البناء.

### 4. النشر
```bash
firebase deploy --only hosting
```

---

## ملاحظة مهمة

مشروع `incm-c87aa` الموجود في `firebase_options.dart` قد يكون:
- مشروعاً أنشأه شخص آخر → اطلب إضافتك كمحرر
- أو أنشئ مشروعاً جديداً وحدّث `firebase_options.dart` عبر FlutterFire CLI:
  ```bash
  dart run flutterfire_cli:flutterfire configure
  ```

بعد النشر ستظهر لك روابط مثل:
- `https://incm-c87aa.web.app`
- `https://incm-c87aa.firebaseapp.com`
