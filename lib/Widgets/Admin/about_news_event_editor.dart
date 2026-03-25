import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'image_picker_widget.dart';
import 'text_editor_widget.dart';

class AboutNewsEventEditor extends StatefulWidget {
  final int eventIndex;
  final AboutNewsEventDraft? initialDraft;
  final ValueChanged<AboutNewsEventDraft> onSave;

  const AboutNewsEventEditor({
    super.key,
    required this.eventIndex,
    this.initialDraft,
    required this.onSave,
  });

  @override
  State<AboutNewsEventEditor> createState() => _AboutNewsEventEditorState();
}

class _AboutNewsEventEditorState extends State<AboutNewsEventEditor> {
  late final TextEditingController _titleEnController;
  late final TextEditingController _titleArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _titleEnController = TextEditingController(
      text: widget.initialDraft?.titleEn ?? '',
    );
    _titleArController = TextEditingController(
      text: widget.initialDraft?.titleAr ?? '',
    );
    _descriptionEnController = TextEditingController(
      text: widget.initialDraft?.descriptionEn ?? '',
    );
    _descriptionArController = TextEditingController(
      text: widget.initialDraft?.descriptionAr ?? '',
    );
    _imageBase64 = widget.initialDraft?.imageBase64;
  }

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleEnController.text.trim().isEmpty &&
        _titleArController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان للخبر')),
      );
      return;
    }

    if (_descriptionEnController.text.trim().isEmpty &&
        _descriptionArController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال وصف للخبر')),
      );
      return;
    }

    if (_imageBase64 == null || _imageBase64!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة للخبر')),
      );
      return;
    }

    widget.onSave(
      AboutNewsEventDraft(
        titleEn: _titleEnController.text.trim(),
        titleAr: _titleArController.text.trim(),
        descriptionEn: _descriptionEnController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        imageBase64: _imageBase64!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialDraft != null;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 800),
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
                      isEditing
                          ? 'تعديل Event ${widget.eventIndex}'
                          : 'إضافة Event جديد ${widget.eventIndex}',
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
                label: 'العنوان بالإنجليزية',
                initialValue: _titleEnController.text,
                onChanged: (value) => _titleEnController.text = value,
                maxLines: 2,
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'العنوان بالعربية',
                initialValue: _titleArController.text,
                onChanged: (value) => _titleArController.text = value,
                maxLines: 2,
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'الوصف بالإنجليزية',
                initialValue: _descriptionEnController.text,
                onChanged: (value) => _descriptionEnController.text = value,
                maxLines: 4,
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'الوصف بالعربية',
                initialValue: _descriptionArController.text,
                onChanged: (value) => _descriptionArController.text = value,
                maxLines: 4,
              ),
              SizedBox(height: 16.h),
              ImagePickerWidget(
                label: 'الصورة',
                initialBase64: _imageBase64,
                onImageSelected: (base64) {
                  setState(() {
                    _imageBase64 = base64;
                  });
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4ED47),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('حفظ'),
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

class AboutNewsEventDraft {
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String imageBase64;

  const AboutNewsEventDraft({
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.imageBase64,
  });
}
