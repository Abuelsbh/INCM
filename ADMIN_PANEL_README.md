# لوحة التحكم - Admin Panel

تم إنشاء لوحة تحكم كاملة لإدارة محتوى التطبيق بالكامل.

## المميزات

- ✅ إدارة المحتوى النصي (عربي/إنجليزي) لجميع الصفحات
- ✅ إدارة الصور (تخزين كـ base64)
- ✅ إضافة/تعديل/حذف المحتوى
- ✅ دعم جميع صفحات التطبيق
- ✅ واجهة مستخدم سهلة بالعربية

## كيفية الوصول للوحة التحكم

افتح التطبيق وانتقل إلى المسار:
```
/admin
```

## البنية الأساسية

### 1. Models
- `ContentModel`: نموذج لإدارة المحتوى (نص، صورة، فيديو، رابط)
- `PageContentModel`: نموذج لتنظيم المحتوى حسب الصفحة

### 2. Services
- `FirebaseContentService`: خدمة Firebase لإدارة المحتوى في Firestore

### 3. Providers
- `ContentProvider`: Provider لإدارة حالة المحتوى في التطبيق

### 4. Widgets
- `ImagePickerWidget`: Widget لاختيار الصور وتحويلها لـ base64
- `TextEditorWidget`: Widget لتحرير النصوص
- `ContentItemEditor`: Widget لتحرير عنصر محتوى كامل
- `Base64ImageWidget`: Widget لعرض الصور من base64

### 5. Screens
- `AdminPanelScreen`: الشاشة الرئيسية للوحة التحكم

## كيفية استخدام لوحة التحكم

### إضافة محتوى جديد

1. اختر الصفحة من القائمة الجانبية
2. اضغط على "إضافة محتوى"
3. أدخل:
   - **Section ID**: معرف القسم (مثل: `hero-title`, `background-image`)
   - **نوع المحتوى**: نص أو صورة
   - **المحتوى**: النص أو الصورة حسب النوع
4. اضغط "حفظ"

### تعديل محتوى موجود

1. اختر الصفحة من القائمة الجانبية
2. اضغط على أيقونة التعديل (✏️) بجانب المحتوى
3. عدّل المحتوى
4. اضغط "حفظ"

### حذف محتوى

1. اختر الصفحة من القائمة الجانبية
2. اضغط على أيقونة الحذف (🗑️) بجانب المحتوى
3. أكد الحذف

## استخدام المحتوى في الشاشات

### استخدام النصوص

```dart
import 'package:incm/core/Content/content_helper.dart';

// في build method
FutureBuilder<String>(
  future: ContentHelper.getText(
    context,
    'corporate-leasing', // pageId
    'hero-title',        // sectionId
    defaultValue: 'CORPORATE', // القيمة الافتراضية
  ),
  builder: (context, snapshot) {
    return Text(snapshot.data ?? 'CORPORATE');
  },
)
```

### استخدام الصور

```dart
// كـ Widget
FutureBuilder<Widget>(
  future: ContentHelper.getImage(
    context,
    'corporate-leasing',
    'background-image',
    fallbackAssetPath: Assets.imagesService1,
  ),
  builder: (context, snapshot) {
    return snapshot.data ?? Image.asset(Assets.imagesService1);
  },
)

// كـ DecorationImage
FutureBuilder<DecorationImage?>(
  future: ContentHelper.getDecorationImage(
    context,
    'corporate-leasing',
    'background-image',
  ),
  builder: (context, snapshot) {
    return Container(
      decoration: BoxDecoration(
        image: snapshot.data ?? DecorationImage(
          image: AssetImage(Assets.imagesService1),
        ),
      ),
    );
  },
)
```

## هيكل البيانات في Firebase

### Collection: `app_content`

```json
{
  "id": "auto-generated-id",
  "pageId": "corporate-leasing",
  "sectionId": "hero-title",
  "type": "text",
  "values": {
    "en": "CORPORATE",
    "ar": "الشركات"
  },
  "imageBase64": null,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## الصفحات المدعومة

- `home`: الصفحة الرئيسية
- `about`: من نحن
- `contacts`: اتصل بنا
- `career`: الوظائف
- `buy`: شراء
- `sell`: بيع
- `lease`: إيجار
- `corporate-leasing`: إيجار الشركات
- `retail-leasing`: إيجار التجزئة
- `medical-leasing`: إيجار طبي
- `facility-management`: إدارة المرافق
- `franchise-investment`: استثمار الامتياز
- `primary-investment`: الاستثمار الأساسي
- `marketing`: التسويق
- `consultation`: الاستشارة
- `services`: الخدمات
- `all-logos`: جميع الشعارات

## ملاحظات مهمة

1. **الصور**: يتم تخزين جميع الصور كـ base64 string في Firestore
2. **الأداء**: يتم استخدام cache لتقليل استدعاءات Firebase
3. **الأمان**: تأكد من إعداد قواعد Firestore بشكل صحيح
4. **النسخ الاحتياطي**: يُنصح بعمل نسخ احتياطي من بيانات Firestore

## إعداد Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /app_content/{document=**} {
      allow read: if true; // للقراءة العامة
      allow write: if request.auth != null; // للكتابة فقط للمستخدمين المسجلين
    }
  }
}
```

## المتطلبات

- Firebase Core
- Cloud Firestore
- Image Picker (لاختيار الصور)
- Provider (لإدارة الحالة)

## الخطوات التالية

1. قم بتشغيل `flutter pub get` لتثبيت الحزم الجديدة
2. تأكد من تهيئة Firebase بشكل صحيح
3. افتح التطبيق وانتقل إلى `/admin`
4. ابدأ بإضافة المحتوى!












