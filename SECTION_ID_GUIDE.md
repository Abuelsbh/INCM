# دليل Section ID - معرف القسم

## ما هو Section ID؟

**Section ID** هو معرف فريد لكل عنصر محتوى في الصفحة. يستخدم لتحديد موقع المحتوى بدقة في الصفحة.

## كيف يعمل؟

عند إضافة محتوى جديد في لوحة التحكم، تحتاج إلى:
1. **Page ID**: معرف الصفحة (مثل: `corporate-leasing`, `home`, `about`)
2. **Section ID**: معرف القسم داخل الصفحة (مثل: `hero-title`, `background-image`)

## أمثلة عملية

### مثال 1: صفحة Corporate Leasing

في صفحة `corporate-leasing` يمكنك إضافة:

| Section ID | النوع | الوصف | الاستخدام |
|------------|-------|-------|-----------|
| `hero-title-1` | text | العنوان الأول "CORPORATE" | النص الأبيض الكبير |
| `hero-title-2` | text | العنوان الثاني "LEASING" | النص الأصفر الكبير |
| `hero-subtitle` | text | النص الفرعي | "Your workspace shapes your success..." |
| `background-image` | image | الصورة الخلفية | صورة الخلفية الرئيسية |
| `experience-text` | text | نص الخبرة | "We have extensive experience..." |
| `locations-text` | text | نص المواقع | "Strategic locations..." |
| `service-1` | text | الخدمة الأولى | "Large Inventory..." |
| `service-2` | text | الخدمة الثانية | "Flexible Payment..." |
| `service-3` | text | الخدمة الثالثة | "Smart Solutions..." |
| `service-4` | text | الخدمة الرابعة | "Full Support..." |

### مثال 2: الصفحة الرئيسية (Home)

| Section ID | النوع | الوصف |
|------------|-------|-------|
| `welcome-title` | text | عنوان الترحيب |
| `welcome-subtitle` | text | النص الفرعي |
| `hero-background` | image | صورة الخلفية |
| `about-title` | text | عنوان قسم "من نحن" |
| `about-description` | text | وصف قسم "من نحن" |

### مثال 3: صفحة About Us

| Section ID | النوع | الوصف |
|------------|-------|-------|
| `who-are-we-title` | text | عنوان "من نحن" |
| `who-are-we-text` | text | النص الكامل |
| `mission-title` | text | عنوان "مهمتنا" |
| `mission-text` | text | نص المهمة |
| `vision-title` | text | عنوان "رؤيتنا" |
| `vision-text` | text | نص الرؤية |
| `about-background` | image | صورة الخلفية |

## أفضل الممارسات لاختيار Section IDs

### ✅ جيد:
- `hero-title` - واضح ومباشر
- `background-image` - يصف الوظيفة
- `service-1`, `service-2` - منظم ومرتب
- `contact-phone` - وصفي
- `footer-copyright` - واضح

### ❌ سيء:
- `section1`, `section2` - غير وصفي
- `text` - عام جداً
- `image` - لا يحدد الموقع
- `123` - غير واضح

## كيفية استخدام Section ID في الكود

### في الشاشات:

```dart
// الحصول على نص
final title = await ContentHelper.getText(
  context,
  'corporate-leasing',  // Page ID
  'hero-title-1',      // Section ID
  defaultValue: 'CORPORATE', // القيمة الافتراضية
);

// الحصول على صورة
final image = await ContentHelper.getImage(
  context,
  'corporate-leasing',
  'background-image',
  fallbackAssetPath: Assets.imagesService1,
);
```

### في لوحة التحكم:

1. اختر الصفحة (مثل: `corporate-leasing`)
2. اضغط "إضافة محتوى"
3. أدخل Section ID (مثل: `hero-title-1`)
4. اختر النوع (نص أو صورة)
5. أدخل المحتوى
6. احفظ

## هيكل البيانات في Firebase

```json
{
  "pageId": "corporate-leasing",
  "sectionId": "hero-title-1",
  "type": "text",
  "values": {
    "en": "CORPORATE",
    "ar": "الشركات"
  }
}
```

## نصائح مهمة

1. **استخدم أسماء واضحة**: `hero-title` أفضل من `title1`
2. **كن متسقاً**: استخدم نفس النمط في جميع الصفحات
3. **استخدم واصفات**: `background-image` أفضل من `img`
4. **استخدم أرقام للقوائم**: `service-1`, `service-2` منظم
5. **تجنب المسافات**: استخدم `-` أو `_` بدلاً من المسافات

## أمثلة من الكود الحالي

### في corporate_leasing_screen.dart:

```dart
// يمكن استبدال هذا:
Text('CORPORATE'.tr)

// بهذا:
FutureBuilder<String>(
  future: ContentHelper.getText(
    context,
    'corporate-leasing',
    'hero-title-1',
    defaultValue: 'CORPORATE',
  ),
  builder: (context, snapshot) => Text(snapshot.data ?? 'CORPORATE'),
)
```

## قائمة Section IDs المقترحة لكل صفحة

### Corporate Leasing (`corporate-leasing`):
- `hero-title-1` (CORPORATE)
- `hero-title-2` (LEASING)
- `hero-subtitle`
- `background-image`
- `experience-text`
- `locations-text`
- `service-1` إلى `service-4`

### Home (`home`):
- `welcome-title`
- `welcome-subtitle`
- `hero-background`
- `about-section-title`
- `services-section-title`

### About (`about`):
- `who-are-we-title`
- `who-are-we-text`
- `mission-title`
- `mission-text`
- `vision-title`
- `vision-text`
- `about-background`

## خلاصة

**Section ID** = معرف فريد لكل عنصر محتوى في الصفحة
- يساعدك في تحديد موقع المحتوى بدقة
- يسهل إدارة المحتوى من لوحة التحكم
- يجعل الكود أكثر مرونة وقابلية للصيانة












