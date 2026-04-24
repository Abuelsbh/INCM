import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/Language/locales.dart';
import 'image_picker_widget.dart';

class ExclusiveLeasingProjectDraft {
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String? logoBase64;
  final List<String?> galleryBase64;

  const ExclusiveLeasingProjectDraft({
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.logoBase64,
    required this.galleryBase64,
  });

  /// Non-null slots in order (saved as image-0 .. image-n).
  List<String> get nonEmptyGallery {
    return galleryBase64.whereType<String>().where((s) => s.trim().isNotEmpty).toList();
  }
}

class ExclusiveLeasingProjectEditor extends StatefulWidget {
  final String? fixedSlug;
  final ExclusiveLeasingProjectDraft? initialDraft;
  final Set<String> reservedSlugs;
  /// Returns true when save and upload finished successfully (dialog will close).
  final Future<bool> Function(String slug, ExclusiveLeasingProjectDraft draft) onSave;

  const ExclusiveLeasingProjectEditor({
    super.key,
    this.fixedSlug,
    this.initialDraft,
    this.reservedSlugs = const {},
    required this.onSave,
  });

  @override
  State<ExclusiveLeasingProjectEditor> createState() =>
      _ExclusiveLeasingProjectEditorState();
}

class _ExclusiveLeasingProjectEditorState extends State<ExclusiveLeasingProjectEditor> {
  late final TextEditingController _slugController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _titleArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;
  String? _logoBase64;
  late List<String?> _gallery;
  bool _isSaving = false;

  bool get _isEditing => widget.fixedSlug != null && widget.fixedSlug!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDraft;
    _slugController = TextEditingController();
    _titleEnController = TextEditingController(text: d?.titleEn ?? '');
    _titleArController = TextEditingController(text: d?.titleAr ?? '');
    _descriptionEnController = TextEditingController(text: d?.descriptionEn ?? '');
    _descriptionArController = TextEditingController(text: d?.descriptionAr ?? '');
    _logoBase64 = d?.logoBase64;
    _gallery = List<String?>.from(d?.galleryBase64 ?? [null]);
    if (_gallery.isEmpty) {
      _gallery = [null];
    }
  }

  @override
  void dispose() {
    _slugController.dispose();
    _titleEnController.dispose();
    _titleArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    super.dispose();
  }

  String _proposeSlugFromTitle(String en, String ar) {
    final raw = en.trim().isNotEmpty ? en : ar;
    if (raw.isEmpty) return '';
    var s = raw.toLowerCase().trim();
    s = s.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    s = s.replaceAll(RegExp(r'-+'), '-');
    s = s.replaceAll(RegExp(r'^-|-\$'), '');
    return s;
  }

  Future<void> _save() async {
    final titleEn = _titleEnController.text.trim();
    final titleAr = _titleArController.text.trim();
    final descEn = _descriptionEnController.text.trim();
    final descAr = _descriptionArController.text.trim();

    if (titleEn.isEmpty && titleAr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('EXCLUSIVE_LEASING_TITLE_REQUIRED'.tr(context))),
      );
      return;
    }
    if (descEn.isEmpty && descAr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('EXCLUSIVE_LEASING_DESC_REQUIRED'.tr(context))),
      );
      return;
    }

    String slug;
    if (_isEditing) {
      slug = widget.fixedSlug!.trim();
    } else {
      var raw = _slugController.text.trim();
      if (raw.isEmpty) {
        raw = _proposeSlugFromTitle(titleEn, titleAr);
      }
      slug = raw.toLowerCase().replaceAll(RegExp(r'[^a-z0-9-]'), '-');
      slug = slug.replaceAll(RegExp(r'-+'), '-');
      slug = slug.replaceAll(RegExp(r'^-|-\$'), '');
      if (slug.isEmpty) {
        slug = 'project-${DateTime.now().millisecondsSinceEpoch}';
      }
      if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(slug)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('EXCLUSIVE_LEASING_SLUG_INVALID'.tr(context))),
        );
        return;
      }
      var candidate = slug;
      var n = 2;
      final reserved = widget.reservedSlugs.difference({widget.fixedSlug ?? ''});
      while (reserved.contains(candidate)) {
        candidate = '$slug-$n';
        n++;
      }
      slug = candidate;
    }

    final draft = ExclusiveLeasingProjectDraft(
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descEn,
      descriptionAr: descAr,
      logoBase64: _logoBase64,
      galleryBase64: List<String?>.from(_gallery),
    );

    setState(() => _isSaving = true);
    // Let the first frame paint the overlay so the UI does not look "hard frozen".
    await WidgetsBinding.instance.endOfFrame;
    try {
      final ok = await widget.onSave(slug, draft);
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERROR_SAVING_CONTENT'.tr(context))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickMultipleGalleryImages() async {
    try {
      final List<List<int>> rawBytesList;

      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['jpg', 'jpeg', 'png', 'gif', 'webp'],
          withData: true,
          allowMultiple: true,
        );
        if (result == null || result.files.isEmpty) return;
        rawBytesList = result.files
            .where((f) => f.bytes != null && f.bytes!.isNotEmpty)
            .map((f) => f.bytes!)
            .toList();
      } else {
        final picker = ImagePicker();
        final images = await picker.pickMultiImage(
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 88,
        );
        if (images.isEmpty) return;
        rawBytesList = [];
        for (final x in images) {
          rawBytesList.add(await x.readAsBytes());
        }
      }

      if (rawBytesList.isEmpty) return;

      var skipCount = 0;
      setState(() {
        final hadOnlyPlaceholders = _gallery.isEmpty ||
            _gallery.every((s) => s == null || s.trim().isEmpty);
        if (hadOnlyPlaceholders) {
          _gallery = [];
        }
        for (final bytes in rawBytesList) {
          if (_gallery.length >= 10) {
            skipCount++;
            continue;
          }
          _gallery.add(base64Encode(bytes));
        }
        if (_gallery.isEmpty) {
          _gallery = [null];
        }
      });

      if (skipCount > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'EXCLUSIVE_LEASING_GALLERY_SKIP_EXTRA'.tr(context).replaceAll('{n}', '$skipCount'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR_PICKING_IMAGE'.tr(context).replaceAll('{error}', e.toString())),
          ),
        );
      }
    }
  }

  void _addGallerySlot() {
    if (_gallery.length >= 10) return;
    setState(() => _gallery.add(null));
  }

  void _removeGalleryAt(int index) {
    setState(() {
      _gallery.removeAt(index);
      if (_gallery.isEmpty) {
        _gallery = [null];
      }
    });
  }

  Widget _labeledField(String label, TextEditingController c, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        TextField(
          controller: c,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _isEditing;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: PopScope(
        canPop: !_isSaving,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          constraints: const BoxConstraints(maxWidth: 880),
          padding: EdgeInsets.all(20.w),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              Text(
                isEditing ? 'Edit project' : 'Add project',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              if (!isEditing) ...[
                TextField(
                  controller: _slugController,
                  decoration: const InputDecoration(
                    labelText: 'Project ID (optional)',
                    hintText: 'e.g. my-new-mall — auto-filled from English title if empty',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              _labeledField('Title (EN)', _titleEnController, maxLines: 1),
              SizedBox(height: 12.h),
              _labeledField('Title (AR)', _titleArController, maxLines: 1),
              SizedBox(height: 12.h),
              _labeledField('Description (EN)', _descriptionEnController, maxLines: 5),
              SizedBox(height: 12.h),
              _labeledField('Description (AR)', _descriptionArController, maxLines: 5),
              SizedBox(height: 16.h),
              ImagePickerWidget(
                label: 'Logo (optional — site uses default if empty)',
                initialBase64: _logoBase64,
                enabled: !_isSaving,
                onImageSelected: (b64) => setState(() => _logoBase64 = b64.isEmpty ? null : b64),
              ),
              SizedBox(height: 16.h),
              Text(
                'Gallery images (optional, max 10)',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Wrap(
                  spacing: 4.w,
                  runSpacing: 4.h,
                  alignment: WrapAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _isSaving || _gallery.length >= 10 ? null : _addGallerySlot,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('Add slot'),
                    ),
                    TextButton.icon(
                      onPressed: _isSaving || _gallery.length >= 10 ? null : _pickMultipleGalleryImages,
                      icon: const Icon(Icons.library_add_outlined),
                      label: Text('EXCLUSIVE_LEASING_ADD_MULTIPLE_IMAGES'.tr(context)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              ...List.generate(_gallery.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ImagePickerWidget(
                          label: 'Image ${i + 1}',
                          initialBase64: _gallery[i],
                          enabled: !_isSaving,
                          onImageSelected: (b64) =>
                              setState(() => _gallery[i] = b64.isEmpty ? null : b64),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: _isSaving || _gallery.length <= 1
                            ? null
                            : () => _removeGalleryAt(i),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving ? null : () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4ED47),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isSaving)
                Positioned.fill(
                  child: Material(
                    color: Colors.black54,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: Color(0xFFF4ED47)),
                            SizedBox(height: 20.h),
                            Text(
                              'EXCLUSIVE_LEASING_UPLOADING_WAIT'.tr(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
