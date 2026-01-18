# صور مشاريع Exclusive Leasing Projects

هذا المجلد يحتوي على الصور المحلية (Local Fallback Images) لمشاريع Exclusive Leasing.

## هيكل المجلدات

كل مشروع له مجلد خاص به:

```
exclusive-leasing/
├── city-square/     # صور City Square
├── kernel/          # صور Kernel
├── park-mall/       # صور Park Mall
├── point90/         # صور Point 90
├── seashell/        # صور Seashell
├── terrace/         # صور Terrace
├── umc/             # صور UMC
└── vitali/          # صور Vitali
```

## تسمية الملفات

لكل مشروع، يمكنك إضافة صور متعددة باستخدام التسمية التالية:

- `image-0.png` أو `image-0.jpg` - الصورة الأولى
- `image-1.png` أو `image-1.jpg` - الصورة الثانية
- `image-2.png` أو `image-2.jpg` - الصورة الثالثة
- ... وهكذا حتى `image-19.png`

## أمثلة

### City Square
```
city-square/
├── image-0.png
├── image-1.png
├── image-2.png
└── ...
```

### Kernel
```
kernel/
├── image-0.png
├── image-1.png
└── ...
```

## ملاحظات مهمة

1. **الصيغ المدعومة**: PNG, JPG, JPEG, WEBP
2. **الحجم الموصى به**: 
   - للويب: 600x600 بكسل (مربع)
   - للموبايل: 400x400 بكسل (مربع)
3. **الحجم الملف**: يُفضل أن يكون أقل من 2MB لكل صورة
4. **الاستخدام**: هذه الصور تستخدم كـ fallback images عند عدم توفر صور من Firebase

## كيفية إضافة الصور

### الطريقة 1: إضافة الصور محلياً
1. ضع الصور في المجلد المناسب للمشروع
2. استخدم التسمية `image-0.png`, `image-1.png`, إلخ
3. قم بتشغيل `flutter pub run build_runner build` لتحديث ملف Assets

### الطريقة 2: إضافة الصور عبر Firebase (مُوصى به)
1. افتح لوحة التحكم: `/admin`
2. اختر الصفحة: `exclusive-leasing-projects`
3. أضف محتوى جديد
4. Section ID: `[project-id]-image-0`, `[project-id]-image-1`, إلخ
5. نوع المحتوى: صورة
6. ارفع الصورة

## قائمة Section IDs للمشاريع

### City Square
- `city-square-image-0` إلى `city-square-image-19`

### Kernel
- `kernel-image-0` إلى `kernel-image-19`

### Park Mall
- `park-mall-image-0` إلى `park-mall-image-19`

### Point 90
- `point90-image-0` إلى `point90-image-19`

### Seashell
- `seashell-image-0` إلى `seashell-image-19`

### Terrace
- `terrace-image-0` إلى `terrace-image-19`

### UMC
- `umc-image-0` إلى `umc-image-19`

### Vitali
- `vitali-image-0` إلى `vitali-image-19`

## تحديث الكود

بعد إضافة الصور محلياً، يجب تحديث ملف `exclusive_leasing_projects_screen.dart` لاستخدام الصور الجديدة في قائمة `localImages` لكل مشروع.

