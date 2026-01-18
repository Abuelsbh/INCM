# دليل إضافة محتوى صفحة Exclusive Leasing Projects من لوحة التحكم

## خطوات الوصول للوحة التحكم

1. افتح التطبيق
2. اذهب إلى المسار: `/admin`
3. أو اضغط على أيقونة القائمة (☰) واختر "لوحة التحكم" (يظهر في وضع التطوير فقط)

## إضافة صور للمشاريع

### خطوة بخطوة:

#### 1. اختر الصفحة
- من القائمة الجانبية، اختر: **"exclusive-leasing-projects"**

#### 2. إضافة صورة جديدة
- اضغط على زر **"إضافة محتوى"** (+ أو زر أخضر)

#### 3. املأ البيانات:

**أ) اختيار Section ID:**
- من القائمة المنسدلة، اختر Section ID الخاص بالصورة التي تريد إضافتها
- أمثلة للصور المتاحة:

**للمشروع UMC:**
- `umc-image-0` - الصورة الأولى
- `umc-image-1` - الصورة الثانية
- `umc-image-2` - الصورة الثالثة
- `umc-image-3` - الصورة الرابعة
- ... حتى `umc-image-9` (الصورة العاشرة)

**للمشروع PARK MALL:**
- `park-mall-image-0` - الصورة الأولى
- `park-mall-image-1` - الصورة الثانية
- ... حتى `park-mall-image-9`

**للمشاريع الأخرى:**
- `terrace-image-0` إلى `terrace-image-9`
- `point90-image-0` إلى `point90-image-9`
- `kernel-image-0` إلى `kernel-image-9`
- `city-square-image-0` إلى `city-square-image-9`
- `vitali-image-0` إلى `vitali-image-9`
- `seashell-image-0` إلى `seashell-image-9`

**ب) نوع المحتوى:**
- سيتم اختيار **"صورة"** تلقائياً عند اختيار Section ID يحتوي على `image`

**ج) رفع الصورة:**
- اضغط على **"اختر صورة"**
- اختر الصورة من جهازك
- سيتم تحميلها تلقائياً وتحويلها إلى base64

#### 4. حفظ
- اضغط على زر **"حفظ"**
- الصورة ستظهر في الصفحة تلقائياً

## إضافة/تعديل محتوى آخر

### إضافة اللوجو:
1. Section ID: `[project-id]-logo`
   - مثال: `umc-logo` أو `park-mall-logo`
2. نوع المحتوى: **صورة**

### تعديل العنوان:
1. Section ID: `[project-id]-title`
   - مثال: `umc-title`
2. نوع المحتوى: **نص**
3. أدخل العنوان بالإنجليزية والعربية

### تعديل الوصف:
1. Section ID: `[project-id]-description`
   - مثال: `umc-description`
2. نوع المحتوى: **نص**
3. أدخل الوصف بالإنجليزية والعربية

## أمثلة عملية

### مثال 1: إضافة صورة أولى لمشروع UMC

```
1. اختر الصفحة: exclusive-leasing-projects
2. اضغط: إضافة محتوى
3. Section ID: umc-image-0
4. نوع المحتوى: صورة (تلقائي)
5. اختر الصورة من جهازك
6. اضغط: حفظ
```

### مثال 2: إضافة صورة ثانية لمشروع PARK MALL

```
1. اختر الصفحة: exclusive-leasing-projects
2. اضغط: إضافة محتوى
3. Section ID: park-mall-image-1
4. نوع المحتوى: صورة
5. اختر الصورة
6. اضغط: حفظ
```

### مثال 3: تعديل عنوان مشروع TERRACE

```
1. اختر الصفحة: exclusive-leasing-projects
2. اضغط على أيقونة التعديل (✏️) بجانب المحتوى
   أو اضغط: إضافة محتوى (إذا غير موجود)
3. Section ID: terrace-title
4. نوع المحتوى: نص
5. أدخل العنوان بالإنجليزية والعربية
6. اضغط: حفظ
```

## ملاحظات مهمة

1. **ترتيب الصور:** الصور تظهر بالترتيب حسب رقمها (0, 1, 2, 3...)

2. **عدد الصور:** يمكن إضافة حتى **20 صورة** لكل مشروع
   - من `image-0` إلى `image-19`
   - إذا أردت إضافة أكثر من 10 صور، استخدم `image-10`, `image-11`, إلخ

3. **السهام:** تظهر تلقائياً عند وجود أكثر من صورة واحدة

4. **الصورة الأولى:** `image-0` هي الصورة التي تظهر افتراضياً

5. **تعديل/حذف:**
   - للتعديل: اضغط على أيقونة التعديل (✏️)
   - للحذف: اضغط على أيقونة الحذف (🗑️)

## قائمة Section IDs الكاملة للمشاريع الثمانية

### UMC
- `umc-title` (نص)
- `umc-description` (نص)
- `umc-logo` (صورة)
- `umc-image-0` إلى `umc-image-9` (صور)

### PARK MALL
- `park-mall-title` (نص)
- `park-mall-description` (نص)
- `park-mall-logo` (صورة)
- `park-mall-image-0` إلى `park-mall-image-9` (صور)

### TERRACE
- `terrace-title` (نص)
- `terrace-description` (نص)
- `terrace-logo` (صورة)
- `terrace-image-0` إلى `terrace-image-9` (صور)

### POINT 90
- `point90-title` (نص)
- `point90-description` (نص)
- `point90-logo` (صورة)
- `point90-image-0` إلى `point90-image-9` (صور)

### KERNEL
- `kernel-title` (نص)
- `kernel-description` (نص)
- `kernel-logo` (صورة)
- `kernel-image-0` إلى `kernel-image-9` (صور)

### CITY SQUARE
- `city-square-title` (نص)
- `city-square-description` (نص)
- `city-square-logo` (صورة)
- `city-square-image-0` إلى `city-square-image-9` (صور)

### VITALI
- `vitali-title` (نص)
- `vitali-description` (نص)
- `vitali-logo` (صورة)
- `vitali-image-0` إلى `vitali-image-9` (صور)

### SEASHELL
- `seashell-title` (نص)
- `seashell-description` (نص)
- `seashell-logo` (صورة)
- `seashell-image-0` إلى `seashell-image-9` (صور)

## نصائح

- احفظ الصور بحجم مناسب (يفضل أقل من 2MB لكل صورة)
- استخدم صيغ JPG أو PNG
- الصور مربعة في العرض (600x600 على Desktop)
- الصور تظهر تلقائياً في الكاروسيل عند الإضافة











