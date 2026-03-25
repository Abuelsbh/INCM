import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/service_model.dart';
import 'text_editor_widget.dart';

class ServiceEditor extends StatefulWidget {
  final ServiceModel? initialService;
  final ValueChanged<ServiceModel> onSave;

  const ServiceEditor({
    super.key,
    this.initialService,
    required this.onSave,
  });

  @override
  State<ServiceEditor> createState() => _ServiceEditorState();
}

class _ServiceEditorState extends State<ServiceEditor> {
  late final TextEditingController _pageIdController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;

  @override
  void initState() {
    super.initState();
    final s = widget.initialService;
    _pageIdController = TextEditingController(text: s?.pageId ?? '');
    _nameEnController = TextEditingController(text: s?.nameEn ?? '');
    _nameArController = TextEditingController(text: s?.nameAr ?? '');
    _descriptionEnController = TextEditingController(text: s?.descriptionEn ?? '');
    _descriptionArController = TextEditingController(text: s?.descriptionAr ?? '');
  }

  @override
  void dispose() {
    _pageIdController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    super.dispose();
  }

  /// Generate pageId from name (e.g. "Property Management" -> "property-management")
  static String _toPageId(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  void _generatePageIdFromName() {
    final name = _nameEnController.text.trim();
    if (name.isNotEmpty && _pageIdController.text.isEmpty) {
      _pageIdController.text = _toPageId(name);
    }
  }

  void _save() {
    final pageId = _pageIdController.text.trim();
    final nameEn = _nameEnController.text.trim();
    final nameAr = _nameArController.text.trim();

    if (pageId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Page ID is required (e.g. property-management)')),
      );
      return;
    }

    if (nameEn.isEmpty && nameAr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one name (EN or AR)')),
      );
      return;
    }

    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(pageId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Page ID must contain only lowercase letters, numbers, and hyphens')),
      );
      return;
    }

    final service = ServiceModel(
      id: widget.initialService?.id ?? '',
      pageId: pageId,
      nameEn: nameEn.isNotEmpty ? nameEn : nameAr,
      nameAr: nameAr.isNotEmpty ? nameAr : nameEn,
      descriptionEn: _descriptionEnController.text.trim(),
      descriptionAr: _descriptionArController.text.trim(),
      order: widget.initialService?.order ?? 0,
      isCustom: true,
    );

    widget.onSave(service);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialService != null;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Service' : 'Add New Service',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextEditorWidget(
                label: 'Name (English)',
                initialValue: _nameEnController.text,
                onChanged: (v) => _nameEnController.text = v,
                maxLines: 1,
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'Name (Arabic)',
                initialValue: _nameArController.text,
                onChanged: (v) => _nameArController.text = v,
                maxLines: 1,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextEditorWidget(
                      label: 'Page ID (e.g. property-management)',
                      initialValue: _pageIdController.text,
                      onChanged: (v) => _pageIdController.text = v,
                      maxLines: 1,
                    ),
                  ),
                  if (!isEditing) ...[
                    SizedBox(width: 12.w),
                    TextButton(
                      onPressed: _generatePageIdFromName,
                      child: const Text('Auto from name'),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'Description (English)',
                initialValue: _descriptionEnController.text,
                onChanged: (v) => _descriptionEnController.text = v,
                maxLines: 4,
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'Description (Arabic)',
                initialValue: _descriptionArController.text,
                onChanged: (v) => _descriptionArController.text = v,
                maxLines: 4,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _save,
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
      ),
    );
  }
}
