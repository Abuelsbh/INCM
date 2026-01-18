# كيفية الوصول إلى لوحة التحكم

هناك عدة طرق للوصول إلى لوحة التحكم (Admin Panel):

## الطريقة 1: من القائمة الجانبية (الأسهل) ⭐

1. افتح التطبيق
2. اضغط على أيقونة القائمة (☰) في أعلى الشاشة
3. ستجد خيار "لوحة التحكم" في القائمة
4. اضغط عليه للانتقال إلى لوحة التحكم

**ملاحظة:** هذا الخيار يظهر فقط في وضع التطوير (Debug Mode)

## الطريقة 2: الانتقال المباشر عبر URL

### على الويب:
افتح المتصفح وانتقل إلى:
```
http://localhost:port/admin
```
أو
```
https://your-domain.com/admin
```

### في التطبيق:
استخدم `go_router` للانتقال مباشرة:
```dart
context.go('/admin');
```

## الطريقة 3: استخدام Deep Link

يمكنك إنشاء deep link للوصول السريع:
```
your-app://admin
```

## الطريقة 4: إضافة زر في أي مكان

يمكنك إضافة زر في أي شاشة للوصول إلى لوحة التحكم:

```dart
import 'package:go_router/go_router.dart';
import '../Modules/Admin/admin_panel_screen.dart';

// في أي widget
ElevatedButton(
  onPressed: () => context.go(AdminPanelScreen.routeName),
  child: Text('لوحة التحكم'),
)
```

## ملاحظات مهمة

1. **وضع التطوير:** زر لوحة التحكم في القائمة يظهر فقط في Debug Mode
2. **الأمان:** في الإنتاج، يجب إضافة نظام مصادقة للوصول إلى لوحة التحكم
3. **Firebase:** تأكد من أن Firebase مهيأ بشكل صحيح (راجع `FIREBASE_WEB_SETUP.md`)

## إضافة مصادقة (اختياري)

لإضافة مصادقة للوصول إلى لوحة التحكم، يمكنك:

1. إضافة Firebase Authentication
2. التحقق من صلاحيات المستخدم قبل عرض لوحة التحكم
3. إخفاء زر لوحة التحكم من القائمة العامة

## مثال على إضافة مصادقة:

```dart
// في admin_panel_screen.dart
@override
Widget build(BuildContext context) {
  // التحقق من المصادقة
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || !user.email!.endsWith('@admin.com')) {
    return Scaffold(
      body: Center(
        child: Text('غير مصرح لك بالوصول'),
      ),
    );
  }
  
  // باقي الكود...
}
```












