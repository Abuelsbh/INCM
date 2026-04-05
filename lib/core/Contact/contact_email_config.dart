/// EmailJS + recipient settings من البناء (`dart-define`)، مع إمكانية التجاوز من Firestore
/// (`app_settings/contact_info`) عبر لوحة الأدمن.
///
/// Flutter: pass at build/run, e.g.
/// `--dart-define=EMAILJS_PUBLIC_KEY=xxx --dart-define=EMAILJS_SERVICE_ID=xxx \
///   --dart-define=EMAILJS_TEMPLATE_ID=xxx --dart-define=RECIPIENT_EMAIL=ops@example.com`
///
/// Optional: [recipientDisplayName] maps to `to_name` in EmailJS template.
class ContactEmailConfig {
  const ContactEmailConfig._();

  static const String emailJsPublicKey = String.fromEnvironment(
    'EMAILJS_PUBLIC_KEY',
    defaultValue: '',
  );

  static const String emailJsServiceId = String.fromEnvironment(
    'EMAILJS_SERVICE_ID',
    defaultValue: '',
  );

  static const String emailJsTemplateId = String.fromEnvironment(
    'EMAILJS_TEMPLATE_ID',
    defaultValue: '',
  );

  static const String recipientEmail = String.fromEnvironment(
    'RECIPIENT_EMAIL',
    defaultValue: '',
  );

  /// Shown as `to_name` in template_params; defaults if unset.
  static const String recipientDisplayName = String.fromEnvironment(
    'RECIPIENT_NAME',
    defaultValue: 'INCM',
  );

  /// حقول البناء فقط؛ عند الإرسال تُدمج مع قيم لوحة التحكم إن وُجدت.
  static bool get hasEmailJsClientConfig =>
      emailJsPublicKey.isNotEmpty &&
      emailJsServiceId.isNotEmpty &&
      emailJsTemplateId.isNotEmpty;

  static bool get hasEmailJsCredentials => hasEmailJsClientConfig;
}
