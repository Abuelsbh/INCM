import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/content_model.dart';
import '../../core/Content/section_ids_config.dart';
import 'image_picker_widget.dart';
import 'text_editor_widget.dart';

class ContentItemEditor extends StatefulWidget {
  final ContentModel? initialContent;
  final String pageId;
  final Function(ContentModel) onSave;
  final VoidCallback? onCancel;

  const ContentItemEditor({
    super.key,
    this.initialContent,
    required this.pageId,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<ContentItemEditor> createState() => _ContentItemEditorState();
}

class _ContentItemEditorState extends State<ContentItemEditor> {
  String? _selectedSectionId;
  late ContentType _selectedType;
  final Map<String, TextEditingController> _textControllers = {};
  String? _imageBase64;
  List<SectionIdOption> _availableSectionIds = [];

  @override
  void initState() {
    super.initState();
    final content = widget.initialContent;
    
    // Load available section IDs for this page
    _availableSectionIds = SectionIdsConfig.getSectionIdsForPage(widget.pageId);
    
    _selectedSectionId = content?.sectionId;
    _selectedType = content?.type ?? ContentType.text;
    _imageBase64 = content?.imageBase64;

    // Initialize text controllers for both languages
    _textControllers['en'] = TextEditingController(
      text: content?.values['en'] ?? '',
    );
    _textControllers['ar'] = TextEditingController(
      text: content?.values['ar'] ?? '',
    );
    
    // If editing existing content and section ID not in list, add it
    if (content != null && _selectedSectionId != null) {
      final exists = _availableSectionIds.any((s) => s.id == _selectedSectionId);
      if (!exists) {
        _availableSectionIds.insert(0, SectionIdOption(
          _selectedSectionId!,
          '${_selectedSectionId!} (موجود)',
          content.type.toString().split('.').last,
        ));
      }
    }
  }

  @override
  void dispose() {
    _textControllers['en']?.dispose();
    _textControllers['ar']?.dispose();
    super.dispose();
  }

  void _save() {
    if (_selectedSectionId == null || _selectedSectionId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار معرف القسم')),
      );
      return;
    }

    final content = ContentModel(
      id: widget.initialContent?.id ?? '',
      pageId: widget.pageId,
      sectionId: _selectedSectionId!,
      type: _selectedType,
      values: {
        'en': _textControllers['en']?.text ?? '',
        'ar': _textControllers['ar']?.text ?? '',
      },
      imageBase64: _imageBase64,
      createdAt: widget.initialContent?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(content);
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    widget.initialContent == null
                        ? 'إضافة محتوى جديد'
                        : 'تعديل المحتوى',
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
              // Section ID Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'معرف القسم (Section ID)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSectionId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'اختر معرف القسم',
                    ),
                    items: _availableSectionIds.map((option) {
                      return DropdownMenuItem<String>(
                        value: option.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              option.id,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSectionId = value;
                        // Auto-set type based on suggested type
                        if (value != null) {
                          final option = _availableSectionIds.firstWhere(
                            (s) => s.id == value,
                            orElse: () => SectionIdOption('', '', 'text'),
                          );
                          // Force text type for service items and other text-only sections
                          if (option.suggestedType == 'image' && 
                              !option.id.contains('service') &&
                              !option.id.contains('text') &&
                              !option.id.contains('title') &&
                              !option.id.contains('subtitle') &&
                              !option.id.contains('description')) {
                            _selectedType = ContentType.image;
                          } else {
                            _selectedType = ContentType.text;
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Only show type dropdown if section allows it
              if (_selectedSectionId != null && 
                  !_selectedSectionId!.contains('service') &&
                  !_selectedSectionId!.contains('text') &&
                  !_selectedSectionId!.contains('title') &&
                  !_selectedSectionId!.contains('subtitle') &&
                  !_selectedSectionId!.contains('description'))
                DropdownButtonFormField<ContentType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'نوع المحتوى',
                    border: OutlineInputBorder(),
                  ),
                  items: ContentType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                )
              else
                // For text-only sections, hide type selector and force text type
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20.sp, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Text(
                        'هذا القسم يدعم النصوص فقط',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20.h),
              // Force text type for service items and text-only sections
              if (_selectedSectionId != null && 
                  (_selectedSectionId!.contains('service') ||
                   _selectedSectionId!.contains('text') ||
                   _selectedSectionId!.contains('title') ||
                   _selectedSectionId!.contains('subtitle') ||
                   _selectedSectionId!.contains('description')))
                // Text only sections
                Column(
                  children: [
                    TextEditorWidget(
                      label: 'النص بالإنجليزية',
                      initialValue: _textControllers['en']?.text,
                      onChanged: (value) => _textControllers['en']?.text = value,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.h),
                    TextEditorWidget(
                      label: 'النص بالعربية',
                      initialValue: _textControllers['ar']?.text,
                      onChanged: (value) => _textControllers['ar']?.text = value,
                      maxLines: 3,
                    ),
                  ],
                )
              else if (_selectedType == ContentType.text) ...[
                // Regular text content
                TextEditorWidget(
                  label: 'النص بالإنجليزية',
                  initialValue: _textControllers['en']?.text,
                  onChanged: (value) => _textControllers['en']?.text = value,
                  maxLines: 3,
                ),
                SizedBox(height: 16.h),
                TextEditorWidget(
                  label: 'النص بالعربية',
                  initialValue: _textControllers['ar']?.text,
                  onChanged: (value) => _textControllers['ar']?.text = value,
                  maxLines: 3,
                ),
              ] else if (_selectedType == ContentType.image) ...[
                // Image content (only for background-image and similar)
                ImagePickerWidget(
                  label: 'الصورة',
                  initialBase64: _imageBase64,
                  onImageSelected: (base64) {
                    setState(() {
                      _imageBase64 = base64;
                    });
                  },
                ),
                SizedBox(height: 16.h),
                TextEditorWidget(
                  label: 'وصف الصورة (اختياري)',
                  initialValue: _textControllers['ar']?.text,
                  onChanged: (value) => _textControllers['ar']?.text = value,
                  maxLines: 2,
                ),
              ],
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

  String _getTypeName(ContentType type) {
    switch (type) {
      case ContentType.text:
        return 'نص';
      case ContentType.image:
        return 'صورة';
      case ContentType.video:
        return 'فيديو';
      case ContentType.link:
        return 'رابط';
    }
  }
}












