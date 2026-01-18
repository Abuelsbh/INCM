# دليل تحديث صفحات الخدمات لاستخدام Firebase

## الصفحات المطلوب تحديثها:
1. ✅ CorporateLeasingScreen - تم التحديث
2. 🔄 RetailLeasingScreen - قيد التحديث
3. ⏳ MedicalLeasingScreen
4. ⏳ MarketingScreen
5. ⏳ FacilityManagementScreen
6. ⏳ FranchiseInvestmentScreen
7. ⏳ PrimaryInvestmentScreen
8. ⏳ ConsultationScreen

## الخطوات المطلوبة لكل صفحة:

### 1. إضافة الـ Imports
```dart
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/Content/content_helper.dart';
```

### 2. تحديث الصورة الخلفية
استبدال:
```dart
decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage(...),
    fit: BoxFit.contain,
  ),
),
```

بـ:
```dart
child: FutureBuilder<DecorationImage?>(
  future: ContentHelper.getDecorationImage(
    context,
    'page-id', // مثل 'retail-leasing'
    'background-image',
    fit: BoxFit.contain,
  ),
  builder: (context, snapshot) {
    DecorationImage? decorationImage = snapshot.data;
    if (decorationImage == null) {
      decorationImage = DecorationImage(
        image: AssetImage(...), // Fallback
        fit: BoxFit.contain,
      );
    }
    return Container(
      decoration: BoxDecoration(image: decorationImage),
      ...
    );
  },
),
```

### 3. تحديث النصوص إلى DynamicText
استبدال:
```dart
Text('TEXT')
```

بـ:
```dart
DynamicText(
  pageId: 'page-id',
  sectionId: 'section-id',
  defaultValue: 'TEXT',
  style: TextStyle(...),
)
```

### 4. تحديث ClientsLogosSection
تأكد من وجود:
```dart
ClientsLogosSection(
  pageId: 'page-id', // هذا موجود بالفعل في معظم الصفحات
  ...
)
```

## Section IDs المتاحة لكل صفحة:
راجع `lib/core/Content/section_ids_config.dart` للحصول على قائمة كاملة.












