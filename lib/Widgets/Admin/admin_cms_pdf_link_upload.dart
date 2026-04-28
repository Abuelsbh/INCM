import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/Firebase/cms_pdf_storage_service.dart';

typedef CmsPdfUploadFn = Future<CmsPdfUploadResult> Function({
  required Uint8List bytes,
  required String originalFileName,
});

/// Admin: pick PDF from device, upload to Storage, fill [linkController] for Firestore `link` field.
class AdminCmsPdfLinkUpload extends StatefulWidget {
  const AdminCmsPdfLinkUpload._({
    super.key,
    required this.linkController,
    required this.upload,
    required this.description,
  });

  /// كتيب الامتياز — `franchise-investment` / `franchising-brochure-url`
  factory AdminCmsPdfLinkUpload.franchise({
    Key? key,
    required TextEditingController linkController,
  }) {
    return AdminCmsPdfLinkUpload._(
      key: key,
      linkController: linkController,
      upload: CmsPdfStorageService.uploadFranchiseBrochurePdf,
      description:
          'ارفع ملف PDF من الجهاز. يُخزّن الملف في Firebase ويُربط زر التحميل تلقائياً بعد الضغط على حفظ.',
    );
  }

  /// ملف الشركة — `about` / `company-profile-file`
  factory AdminCmsPdfLinkUpload.companyProfile({
    Key? key,
    required TextEditingController linkController,
  }) {
    return AdminCmsPdfLinkUpload._(
      key: key,
      linkController: linkController,
      upload: CmsPdfStorageService.uploadCompanyProfilePdf,
      description:
          'ارفع ملف PDF ملف الشركة من الجهاز. يُخزّن في Firebase ويُربط زر «Company profile» بعد حفظ المحتوى.',
    );
  }

  final TextEditingController linkController;
  final CmsPdfUploadFn upload;
  final String description;

  @override
  State<AdminCmsPdfLinkUpload> createState() => _AdminCmsPdfLinkUploadState();
}

class _AdminCmsPdfLinkUploadState extends State<AdminCmsPdfLinkUpload> {
  bool _uploading = false;
  String? _lastPickedName;

  Future<void> _pickAndUpload() async {
    if (_uploading) return;
    setState(() => _uploading = true);
    try {
      final pickResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        withData: true,
      );
      if (pickResult == null || pickResult.files.isEmpty) {
        if (mounted) setState(() => _uploading = false);
        return;
      }
      final file = pickResult.files.first;
      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          setState(() => _uploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تعذّر قراءة الملف. جرّب ملف أصغر أو اختر الملف مرة أخرى.'),
            ),
          );
        }
        return;
      }

      final uploadResult = await widget.upload(
        bytes: bytes,
        originalFileName: file.name,
      );
      if (!mounted) return;
      setState(() => _uploading = false);
      if (uploadResult.url == null || uploadResult.url!.isEmpty) {
        final err = uploadResult.errorMessage ?? 'فشل غير معروف';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err, textDirection: TextDirection.rtl),
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'موافق',
              onPressed: () {},
            ),
          ),
        );
        return;
      }
      widget.linkController.text = uploadResult.url!;
      setState(() => _lastPickedName = file.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم رفع «${file.name}». اضغط حفظ لربطه بالموقع.'),
          backgroundColor: Colors.green[800],
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.linkController,
      builder: (context, _) {
        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[800],
            height: 1.4,
          ),
        ),
        SizedBox(height: 12.h),
        if (_uploading) ...[
          const LinearProgressIndicator(),
          SizedBox(height: 8.h),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: _uploading ? null : _pickAndUpload,
              icon: const Icon(Icons.upload_file, size: 20),
              label: const Text('اختر ملف PDF'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4ED47),
                foregroundColor: Colors.black,
              ),
            ),
            if (widget.linkController.text.trim().isNotEmpty)
              TextButton(
                onPressed: _uploading
                    ? null
                    : () {
                        setState(() {
                          widget.linkController.clear();
                          _lastPickedName = null;
                        });
                      },
                child: const Text('مسح الرابط'),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        if (_lastPickedName != null && _lastPickedName!.isNotEmpty)
          Text(
            'آخر ملف محدّد: $_lastPickedName',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
          )
        else if (widget.linkController.text.trim().isNotEmpty)
          Text(
            'يوجد رابط حالي (بعد «حفظ» يبقى مفعّلاً). لاستبدال الملف اضغط «اختر ملف PDF».',
            style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey[800]),
          ),
        SizedBox(height: 8.h),
        Text(
          'الملف: PDF',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
