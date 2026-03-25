/// E.164-style value for Firestore/API, e.g. `+201234567890`.
String contactFullPhone(String countryCode, String phoneDigits) {
  final cc = countryCode.trim().replaceAll(' ', '');
  final d = phoneDigits.trim();
  if (cc.isEmpty) {
    return d.startsWith('+') ? d : '+$d';
  }
  final prefix = cc.startsWith('+') ? cc : '+$cc';
  return '$prefix$d';
}
