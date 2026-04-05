import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import 'contact_email_config.dart';
import '../Firebase/firebase_contact_info_service.dart';

String _emailJsPick(String fromFirestore, String fromEnvironment) {
  final t = fromFirestore.trim();
  return t.isNotEmpty ? t : fromEnvironment.trim();
}

/// Outcome of persisting a contact message and attempting EmailJS delivery.
class ContactSubmissionResult {
  const ContactSubmissionResult({
    required this.firestoreSaved,
    required this.emailSent,
    this.errorMessage,
  });

  final bool firestoreSaved;
  final bool emailSent;
  final String? errorMessage;

  bool get isFullSuccess => firestoreSaved && emailSent;
}

/// Saves to Firestore `contact_messages`, then sends mail via EmailJS REST API.
class ContactSubmissionService {
  ContactSubmissionService._();

  static final ContactSubmissionService instance = ContactSubmissionService._();

  static const _collection = 'contact_messages';
  static const _emailJsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';

  bool get _firebaseReady {
    try {
      Firebase.app();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// [fullPhone] should include country code, e.g. `+201234567890`.
  /// [emailSubject] is used in `template_params.subject`.
  /// [formSourceSlug] stable code: `buy`, `sell`, `lease`, `career`, `contact_page`, `home`, `service`.
  /// [formSourceLabel] localized description for emails / admins (e.g. from `.tr(context)`).
  /// [extraTemplateParams] merged into EmailJS `template_params` (e.g. `department`, `cv_link`).
  Future<ContactSubmissionResult> submit({
    required String name,
    required String fullPhone,
    required String email,
    required String message,
    required String emailSubject,
    required String formSourceSlug,
    required String formSourceLabel,
    Map<String, String>? extraTemplateParams,
  }) async {
    if (!_firebaseReady) {
      return const ContactSubmissionResult(
        firestoreSaved: false,
        emailSent: false,
        errorMessage: 'Firebase not initialized',
      );
    }

    final fs = FirebaseFirestore.instance;
    DocumentReference<Map<String, dynamic>>? docRef;
    final storedMessage = '[$formSourceLabel]\n\n$message';

    try {
      docRef = await fs.collection(_collection).add({
        'name': name,
        'phone': fullPhone,
        'email': email,
        'message': storedMessage,
        'formSource': formSourceSlug,
        'formSourceLabel': formSourceLabel,
        'createdAt': FieldValue.serverTimestamp(),
        'emailSent': false,
      });
    } catch (e) {
      return ContactSubmissionResult(
        firestoreSaved: false,
        emailSent: false,
        errorMessage: e.toString(),
      );
    }

    final contactSettings = await FirebaseContactInfoService().getContactInfo();

    final publicKey = _emailJsPick(
      contactSettings.emailJsPublicKey,
      ContactEmailConfig.emailJsPublicKey,
    );
    final serviceId = _emailJsPick(
      contactSettings.emailJsServiceId,
      ContactEmailConfig.emailJsServiceId,
    );
    final templateId = _emailJsPick(
      contactSettings.emailJsTemplateId,
      ContactEmailConfig.emailJsTemplateId,
    );

    if (publicKey.isEmpty || serviceId.isEmpty || templateId.isEmpty) {
      return const ContactSubmissionResult(
        firestoreSaved: true,
        emailSent: false,
      );
    }

    final toEmail = contactSettings.formRecipientEmail.trim().isNotEmpty
        ? contactSettings.formRecipientEmail.trim()
        : ContactEmailConfig.recipientEmail.trim();
    final toName = contactSettings.formRecipientName.trim().isNotEmpty
        ? contactSettings.formRecipientName.trim()
        : ContactEmailConfig.recipientDisplayName.trim();

    if (toEmail.isEmpty) {
      return const ContactSubmissionResult(
        firestoreSaved: true,
        emailSent: false,
      );
    }

    final templateParams = <String, String>{
      'from_name': name,
      'name': name,
      'from_email': email,
      'email': email,
      'from_phone': fullPhone,
      'phone': fullPhone,
      'message': storedMessage,
      'subject': emailSubject,
      'to_email': toEmail,
      'to_name': toName,
      'time': DateTime.now().toLocal().toString(),
      'form_source_slug': formSourceSlug,
      'form_source_label': formSourceLabel,
      if (extraTemplateParams != null) ...extraTemplateParams,
    };

    final body = jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': templateParams,
    });

    try {
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: const {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        try {
          await docRef.update({
            'emailSent': true,
            'emailSentAt': FieldValue.serverTimestamp(),
          });
        } catch (_) {
          // Email delivered but Firestore flag update failed — still report email sent.
        }
        return const ContactSubmissionResult(
          firestoreSaved: true,
          emailSent: true,
        );
      }
    } catch (_) {
      // Network / client error — data remains in Firestore with emailSent: false.
    }

    return const ContactSubmissionResult(
      firestoreSaved: true,
      emailSent: false,
    );
  }
}
