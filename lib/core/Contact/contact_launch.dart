import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Language/locales.dart';

/// Web layout at or above this width shows a phone number dialog instead of `tel:`.
const double kContactLaunchDesktopWebMinWidth = 600;

/// Strip decorative characters for `tel:` while preserving a leading `+`.
String contactTelDialString(String phone) {
  final trimmed = phone.trim();
  if (trimmed.isEmpty) return trimmed;
  final buf = StringBuffer();
  for (var i = 0; i < trimmed.length; i++) {
    final c = trimmed[i];
    if (c == '+' && buf.isEmpty) {
      buf.write(c);
    } else if (RegExp(r'[0-9]').hasMatch(c)) {
      buf.write(c);
    }
  }
  return buf.toString();
}

/// Digits only for `https://wa.me/<number>` (no leading `+`).
String contactWhatsAppWaMeNumber(String phone) {
  final dial = contactTelDialString(phone);
  if (dial.isEmpty) return dial;
  return dial.startsWith('+') ? dial.substring(1) : dial;
}

bool _useDesktopWebPhoneDialog(BuildContext context) {
  return kIsWeb &&
      MediaQuery.sizeOf(context).width >= kContactLaunchDesktopWebMinWidth;
}

Future<void> _launchUri(
  Uri uri, {
  bool openInNewBrowserTab = false,
}) async {
  final mode = openInNewBrowserTab
      ? LaunchMode.externalApplication
      : LaunchMode.platformDefault;
  final webWindow = openInNewBrowserTab && kIsWeb ? '_blank' : null;
  try {
    await launchUrl(
      uri,
      mode: mode,
      webOnlyWindowName: webWindow,
    );
  } catch (_) {
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: webWindow,
      );
    } catch (_) {}
  }
}

Uri _gmailComposeUri(String to) {
  return Uri.https(
    'mail.google.com',
    '/mail/',
    <String, String>{
      'view': 'cm',
      'fs': '1',
      'to': to,
    },
  );
}

/// On web opens Gmail compose; on native opens the default mail handler (`mailto:`).
Future<void> launchContactEmail(String email) async {
  final trimmed = email.trim();
  if (trimmed.isEmpty) return;

  if (kIsWeb) {
    await _launchUri(_gmailComposeUri(trimmed), openInNewBrowserTab: true);
    return;
  }

  await _launchUri(Uri(scheme: 'mailto', path: trimmed));
}

/// On mobile web and native apps, opens the dialer (`tel:`). On desktop web, shows the number in a dialog.
Future<void> launchContactPhone(BuildContext context, String displayPhone) async {
  final dial = contactTelDialString(displayPhone);
  if (dial.isEmpty) return;

  if (_useDesktopWebPhoneDialog(context)) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('PHONE'.tr(ctx)),
        content: SelectableText(
          displayPhone.trim(),
          textDirection: TextDirection.ltr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'.tr(ctx)),
          ),
        ],
      ),
    );
    return;
  }

  await _launchUri(Uri(scheme: 'tel', path: dial));
}

/// Opens WhatsApp chat via `https://wa.me/`. On web uses a new tab so mobile browsers can hand off to the app.
Future<void> launchContactWhatsApp(String phone) async {
  final number = contactWhatsAppWaMeNumber(phone);
  if (number.isEmpty) return;

  await _launchUri(
    Uri.https('wa.me', number),
    openInNewBrowserTab: kIsWeb,
  );
}
