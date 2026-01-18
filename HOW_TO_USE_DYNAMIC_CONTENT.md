# كيفية استخدام المحتوى الديناميكي في الشاشات

تم تحديث صفحة `Corporate Leasing` كمثال على كيفية قراءة المحتوى من Firebase.

## ما تم إضافته:

### 1. Widgets مساعدة جديدة (`dynamic_content_widget.dart`)

#### `DynamicText`
يعرض نص من Firebase مع fallback للقيمة الافتراضية:
```dart
DynamicText(
  pageId: 'corporate-leasing',
  sectionId: 'hero-title-1',
  defaultValue: 'CORPORATE'.tr,
  style: TextStyle(...),
)
```

#### `DynamicImage`
يعرض صورة من Firebase مع fallback للصورة الثابتة:
```dart
DynamicImage(
  pageId: 'corporate-leasing',
  sectionId: 'background-image',
  fallbackAssetPath: Assets.imagesService1,
  width: 200,
  height: 200,
)
```

#### `DynamicBackgroundContainer`
Container بخلفية من Firebase:
```dart
DynamicBackgroundContainer(
  pageId: 'corporate-leasing',
  sectionId: 'background-image',
  fallbackAssetPath: Assets.imagesService1,
  child: YourContent(),
)
```

## كيفية التطبيق على باقي الصفحات:

### مثال: صفحة Consultation

#### قبل (ثابت):
```dart
Text('CONSULTATION'.tr)
Image.asset(Assets.imagesService2Web)
```

#### بعد (ديناميكي):
```dart
DynamicText(
  pageId: 'consultation',
  sectionId: 'hero-title',
  defaultValue: 'CONSULTATION'.tr,
)

DynamicImage(
  pageId: 'consultation',
  sectionId: 'background-image',
  fallbackAssetPath: Assets.imagesService2Web,
)
```

### مثال: صفحة Home

```dart
// العنوان
DynamicText(
  pageId: 'home',
  sectionId: 'welcome-title',
  defaultValue: 'WELCOME_TO'.tr,
)

// الصورة الخلفية
DynamicBackgroundContainer(
  pageId: 'home',
  sectionId: 'hero-background',
  fallbackAssetPath: Assets.imagesHomeBackground,
  child: YourContent(),
)
```

## الخطوات لتطبيق على صفحة جديدة:

1. **حدد العناصر التي تريد جعلها ديناميكية:**
   - النصوص
   - الصور
   - العناوين

2. **استبدل الكود الثابت:**
   - `Text('TEXT'.tr)` → `DynamicText(...)`
   - `Image.asset(...)` → `DynamicImage(...)`
   - `Container(decoration: BoxDecoration(image: ...))` → `DynamicBackgroundContainer(...)`

3. **استخدم Section IDs الصحيحة:**
   - راجع `section_ids_config.dart` للقائمة الكاملة
   - أو استخدم Section IDs التي أضفتها في لوحة التحكم

4. **أضف fallback values:**
   - القيم الافتراضية تظهر إذا لم يكن هناك محتوى في Firebase
   - هذا يضمن أن التطبيق يعمل حتى بدون اتصال

## مثال كامل - صفحة Corporate Leasing:

تم تحديث جميع العناصر التالية:

✅ **العناوين:**
- `hero-title-1` → العنوان الأول
- `hero-title-2` → العنوان الثاني
- `hero-subtitle` → النص الفرعي

✅ **الصور:**
- `background-image` → الصورة الخلفية

✅ **النصوص:**
- `experience-text` → نص الخبرة
- `locations-text` → نص المواقع
- `service-1` إلى `service-4` → الخدمات

## ملاحظات مهمة:

1. **Fallback مهم:** دائماً أضف `defaultValue` أو `fallbackAssetPath`
2. **Performance:** المحتوى يتم تحميله مرة واحدة ويُخزن في cache
3. **Offline:** إذا لم يكن هناك اتصال، سيظهر المحتوى الافتراضي
4. **Real-time:** التغييرات في Firebase تظهر بعد refresh

## الخطوات التالية:

1. ✅ صفحة Corporate Leasing - **مكتملة**
2. ⏳ صفحة Consultation
3. ⏳ صفحة Home
4. ⏳ صفحة About
5. ⏳ باقي الصفحات

يمكنك تطبيق نفس الطريقة على باقي الصفحات!












