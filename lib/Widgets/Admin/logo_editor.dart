import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/logo_model.dart';
import 'multi_image_picker_widget.dart';
import 'text_editor_widget.dart';

class LogoEditor extends StatefulWidget {
  final LogoModel? initialLogo;
  final Function(LogoModel) onSave;
  final Function(List<LogoModel>)? onSaveBatch; // Optional batch save callback
  final VoidCallback? onCancel;

  const LogoEditor({
    super.key,
    this.initialLogo,
    required this.onSave,
    this.onSaveBatch,
    this.onCancel,
  });

  @override
  State<LogoEditor> createState() => _LogoEditorState();
}

class _LogoEditorState extends State<LogoEditor> {
  late TextEditingController _nameController;
  List<String> _selectedImages = [];
  String? _selectedPageId;
  int _order = 0;

  // Only 8 services pages for logos - English names
  final Map<String, String> _pageNames = {
    'corporate-leasing': 'Corporate Leasing',
    'retail-leasing': 'Retail Leasing',
    'medical-leasing': 'Medical Leasing',
    'facility-management': 'Facility Management',
    'franchise-investment': 'Franchise Investment',
    'primary-investment': 'Primary Investment',
    'marketing': 'Marketing',
    'consultation': 'Consultation',
  };

  @override
  void initState() {
    super.initState();
    final logo = widget.initialLogo;
    _nameController = TextEditingController(text: logo?.name ?? '');
    // If editing existing logo, add its image to the list
    if (logo?.imageBase64 != null && logo!.imageBase64.isNotEmpty) {
      _selectedImages = [logo.imageBase64];
    }
    _selectedPageId = logo?.pageId ?? '';
    _order = logo?.order ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار صورة واحدة على الأقل للوجو'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPageId == null || _selectedPageId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار صفحة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If editing existing logo and only one image selected, update it
    if (widget.initialLogo != null && _selectedImages.length == 1) {
      final logo = LogoModel(
        id: widget.initialLogo!.id,
        name: _nameController.text.trim(),
        imageBase64: _selectedImages.first,
        pageId: _selectedPageId!,
        order: _order,
        createdAt: widget.initialLogo!.createdAt,
        updatedAt: DateTime.now(),
      );
      widget.onSave(logo);
    } else if (_selectedImages.length > 1 && widget.onSaveBatch != null) {
      // If multiple images selected and batch save is available, use it
      final logos = _selectedImages.asMap().entries.map((entry) {
        final index = entry.key;
        return LogoModel(
          id: widget.initialLogo?.id ?? '',
          name: _nameController.text.trim().isEmpty 
              ? '' 
              : '${_nameController.text.trim()} ${index + 1}',
          imageBase64: entry.value,
          pageId: _selectedPageId!,
          order: _order + index,
          createdAt: widget.initialLogo?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();
      
      widget.onSaveBatch!(logos);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('سيتم إضافة ${_selectedImages.length} لوجو'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } else {
      // Fallback: save each one separately
      for (var i = 0; i < _selectedImages.length; i++) {
        final logo = LogoModel(
          id: widget.initialLogo?.id ?? '',
          name: _nameController.text.trim().isEmpty 
              ? '' 
              : '${_nameController.text.trim()} ${i + 1}',
          imageBase64: _selectedImages[i],
          pageId: _selectedPageId!,
          order: _order + i,
          createdAt: widget.initialLogo?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        widget.onSave(logo);
      }
      
      // Show success message
      if (mounted && _selectedImages.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة ${_selectedImages.length} لوجو بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    widget.initialLogo == null
                        ? 'إضافة لوجو (متعددة)'
                        : 'تعديل اللوجو',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onCancel ?? () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              DropdownButtonFormField<String>(
                value: _selectedPageId?.isEmpty ?? true ? null : _selectedPageId,
                decoration: InputDecoration(
                  labelText: 'الصفحة *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _pageNames.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPageId = value;
                  });
                },
              ),
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'اسم اللوجو (اختياري)',
                initialValue: _nameController.text,
                onChanged: (value) => _nameController.text = value,
              ),
              SizedBox(height: 16.h),
              MultiImagePickerWidget(
                label: 'صور اللوجو *',
                initialBase64List: _selectedImages,
                onImagesSelected: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
              ),
              if (_selectedImages.isNotEmpty && _selectedImages.length > 1)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'سيتم إضافة ${_selectedImages.length} لوجو إلى صفحة: ${_pageNames[_selectedPageId] ?? _selectedPageId}',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel ?? () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4ED47),
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _selectedImages.isEmpty 
                          ? 'حفظ'
                          : 'حفظ ${_selectedImages.length > 1 ? '(${_selectedImages.length})' : ''}',
                    ),
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

