import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'image_picker_widget.dart';
import 'text_editor_widget.dart';

class CareerFamilyMemberEditor extends StatefulWidget {
  final int memberIndex;
  final CareerFamilyMemberDraft? initialDraft;
  final ValueChanged<CareerFamilyMemberDraft> onSave;

  const CareerFamilyMemberEditor({
    super.key,
    required this.memberIndex,
    this.initialDraft,
    required this.onSave,
  });

  @override
  State<CareerFamilyMemberEditor> createState() =>
      _CareerFamilyMemberEditorState();
}

class _CareerFamilyMemberEditorState extends State<CareerFamilyMemberEditor> {
  late final TextEditingController _titleEnController;
  late final TextEditingController _titleArController;
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
    _imageBase64 = widget.initialDraft?.imageBase64;
  }

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleArController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleEnController.text.trim().isEmpty &&
        _titleArController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان للعنصر')),
      );
      return;
    }

    if (_imageBase64 == null || _imageBase64!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صورة للعنصر')),
      );
      return;
    }

    widget.onSave(
      CareerFamilyMemberDraft(
        titleEn: _titleEnController.text.trim(),
        titleAr: _titleArController.text.trim(),
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
                          ? 'تعديل Family Member ${widget.memberIndex}'
                          : 'إضافة Family Member جديد ${widget.memberIndex}',
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

class CareerFamilyMemberDraft {
  final String titleEn;
  final String titleAr;
  final String imageBase64;

  const CareerFamilyMemberDraft({
    required this.titleEn,
    required this.titleAr,
    required this.imageBase64,
  });
}
