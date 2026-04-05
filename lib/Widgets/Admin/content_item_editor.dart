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
  bool _useManualInput = false;
  final TextEditingController _manualSectionIdController = TextEditingController();

  bool _isTextOnlySectionId(String? sectionId) {
    if (sectionId == null || sectionId.isEmpty) return false;
    return sectionId.contains('service') ||
        sectionId.contains('text') ||
        sectionId.contains('title') ||
        sectionId.contains('subtitle') ||
        sectionId.contains('description') ||
        sectionId.contains('benefit') ||
        sectionId.contains('performance-highlight');
  }

  @override
  void initState() {
    super.initState();
    final content = widget.initialContent;
    
    // Load available section IDs for this page
    _availableSectionIds = SectionIdsConfig.getSectionIdsForPage(widget.pageId);
    
    _selectedSectionId = content?.sectionId;
    _imageBase64 = content?.imageBase64;
    
    // Initialize manual input controller if editing existing content
    if (content?.sectionId != null) {
      _manualSectionIdController.text = content!.sectionId;
    }

    // Auto-detect type from section ID if editing existing content
    if (content != null && content.sectionId.isNotEmpty) {
      if (content.sectionId.contains('image') || content.sectionId.contains('logo')) {
        // Force image type for image/logo sections, even if saved as text
        _selectedType = ContentType.image;
      } else {
        _selectedType = content.type;
      }
    } else {
      _selectedType = ContentType.text;
    }

    // Initialize text controllers for both languages
    _textControllers['en'] = TextEditingController(
      text: content?.values['en'] ?? '',
    );
    _textControllers['ar'] = TextEditingController(
      text: content?.values['ar'] ?? '',
    );
    _textControllers['link'] = TextEditingController(
      text: content?.values['link'] ?? content?.values['en'] ?? content?.values['ar'] ?? '',
    );
    
    // If editing existing content and section ID not in list, add it
    if (content != null && _selectedSectionId != null) {
      final exists = _availableSectionIds.any((s) => s.id == _selectedSectionId);
      if (!exists) {
        // Determine suggested type based on section ID
        final suggestedType = (_selectedSectionId!.contains('image') || 
                              _selectedSectionId!.contains('logo'))
            ? 'image'
            : content.type.toString().split('.').last;
        _availableSectionIds.insert(0, SectionIdOption(
          _selectedSectionId!,
          '${_selectedSectionId!} (موجود)',
          suggestedType,
        ));
      }
    }
  }

  @override
  void dispose() {
    _textControllers['en']?.dispose();
    _textControllers['ar']?.dispose();
    _textControllers['link']?.dispose();
    _manualSectionIdController.dispose();
    super.dispose();
  }

  void _save() {
    // Get section ID from dropdown or manual input
    final sectionId = _useManualInput 
        ? _manualSectionIdController.text.trim()
        : _selectedSectionId;
    
    if (sectionId == null || sectionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار أو إدخال معرف القسم')),
      );
      return;
    }


    final content = ContentModel(
      id: widget.initialContent?.id ?? '',
      pageId: widget.pageId,
      sectionId: sectionId,
      type: _selectedType,
      values: {
        'en': _textControllers['en']?.text ?? '',
        'ar': _textControllers['ar']?.text ?? '',
        'link': _textControllers['link']?.text.trim() ?? '',
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
              // Section ID Dropdown or Manual Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Row(
                        children: [
                          Text(
                            'إدخال يدوي',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Switch(
                            value: _useManualInput,
                            onChanged: (value) {
                              setState(() {
                                _useManualInput = value;
                                if (value && _selectedSectionId != null) {
                                  _manualSectionIdController.text = _selectedSectionId!;
                                } else if (!value && _manualSectionIdController.text.isNotEmpty) {
                                  _selectedSectionId = _manualSectionIdController.text;
                                }
                                // Auto-detect type from section ID
                                final sectionId = value 
                                    ? _manualSectionIdController.text 
                                    : _selectedSectionId ?? '';
                                if (sectionId.contains('image') || sectionId.contains('logo')) {
                                  _selectedType = ContentType.image;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!_useManualInput)
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
                            if (_isTextOnlySectionId(option.id)) {
                              _selectedType = ContentType.text;
                            } else if (option.suggestedType == 'video') {
                              _selectedType = ContentType.video;
                            } else if (option.suggestedType == 'image') {
                              _selectedType = ContentType.image;
                            } else if (option.suggestedType == 'link') {
                              _selectedType = ContentType.link;
                            } else {
                              _selectedType = ContentType.text;
                            }
                          }
                        });
                      },
                    )
                  else
                    TextField(
                      controller: _manualSectionIdController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'أدخل معرف القسم (مثال: umc-logo أو umc-image-0)',
                        helperText: 'مثال: umc-logo, park-mall-image-0, terrace-logo, إلخ',
                      ),
                      onChanged: (value) {
                        // Auto-detect type from section ID
                        if (value.contains('image') || value.contains('logo')) {
                          setState(() {
                            _selectedType = ContentType.image;
                          });
                        } else if (value.contains('video') || value.contains('media')) {
                          setState(() {
                            _selectedType = ContentType.video;
                          });
                        } else if (value.contains('link') ||
                            value.contains('file') ||
                            value.contains('url')) {
                          setState(() {
                            _selectedType = ContentType.link;
                          });
                        }
                      },
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              // Only show type dropdown if section allows it
              if (!_isTextOnlySectionId(_selectedSectionId))
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
              if (_isTextOnlySectionId(_selectedSectionId))
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
              ] else if (_selectedType == ContentType.link) ...[
                TextEditorWidget(
                  label: 'الرابط',
                  initialValue: _textControllers['link']?.text,
                  onChanged: (value) => _textControllers['link']?.text = value,
                  maxLines: 2,
                  isRequired: true,
                ),
              ] else if (_selectedType == ContentType.video) ...[
                TextEditorWidget(
                  label: 'رابط الفيديو',
                  initialValue: _textControllers['link']?.text,
                  onChanged: (value) => _textControllers['link']?.text = value,
                  maxLines: 2,
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF81C784)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 18.sp, color: Colors.green[800]),
                          SizedBox(width: 6.w),
                          Text(
                            'للعمل على Safari وجميع المتصفحات:',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'ارفع الفيديو على استضافة مجانية تعطي رابط .mp4 مباشر، مثل:\n'
                        '• VidPlay.io • Image2URL.com • Cloudinary',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green[800],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ثم الصق الرابط المباشر هنا (ينتهي عادة بـ .mp4)',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
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












