# إعداد Firebase للويب

## المشكلة
عند تشغيل التطبيق على الويب، قد تواجه خطأ:
```
FirebaseOptions cannot be null when creating the default app.
```

## الحل

### الخطوة 1: إضافة Web App في Firebase Console

1. افتح [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك: `incm-c87aa`
3. اضغط على أيقونة الإعدادات ⚙️ بجانب "Project Overview"
4. اختر "Project settings"
5. انتقل إلى قسم "Your apps"
6. إذا لم يكن هناك Web App، اضغط على أيقونة `</>` لإضافة Web App
7. أدخل اسم التطبيق (مثلاً: "INCM Web")
8. اضغط "Register app"
9. انسخ `appId` من الكود المعروض (سيبدو مثل: `1:75851289116:web:xxxxxxxxxxxxx`)

### الخطوة 2: تحديث firebase_options.dart

افتح الملف: `lib/core/Firebase/firebase_options.dart`

ابحث عن:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyB-UomzDJ7g02oF_3o_vtWYD5pcbmb924k',
  appId: '1:75851289116:web:YOUR_WEB_APP_ID', // TODO: Replace with your Web App ID
  ...
);
```

استبدل `YOUR_WEB_APP_ID` بـ `appId` الذي نسخته من Firebase Console.

### الخطوة 3: إعادة تشغيل التطبيق

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

## ملاحظات

- إذا كنت تريد تشغيل التطبيق على Android/iOS فقط، يمكنك تجاهل هذا الخطأ على الويب
- الكود الحالي يحتوي على try-catch ليتعامل مع هذا الخطأ بشكل آمن
- لوحة التحكم ستعمل فقط على المنصات التي تم تهيئة Firebase عليها بشكل صحيح

## التحقق من الإعداد

بعد تحديث `appId`، يجب أن يعمل Firebase على الويب بدون أخطاء.












