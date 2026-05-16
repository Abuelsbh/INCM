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

bool _useDesktopWebPhoneDialog(BuildContext context) {
  return kIsWeb &&
      MediaQuery.sizeOf(context).width >= kContactLaunchDesktopWebMinWidth;
}

Future<void> _launchUri(Uri uri) async {
  try {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  } catch (_) {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

/// Opens the default mail handler (`mailto:`).
Future<void> launchContactEmail(String email) async {
  final trimmed = email.trim();
  if (trimmed.isEmpty) return;
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
