import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/logo_model.dart';
import 'multi_image_picker_widget.dart';

class BatchLogoEditor extends StatefulWidget {
  final Function(List<LogoModel> logos) onSave;

  const BatchLogoEditor({
    super.key,
    required this.onSave,
  });

  @override
  State<BatchLogoEditor> createState() => _BatchLogoEditorState();
}

class _BatchLogoEditorState extends State<BatchLogoEditor> {
  List<String> _selectedImages = [];
  String? _selectedPageId;
  bool _isSaving = false;

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

  void _save() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select images for the logos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPageId == null || _selectedPageId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a page'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create logo models from selected images
    final logos = _selectedImages.map((imageBase64) {
      return LogoModel(
        id: '',
        name: '',
        imageBase64: imageBase64,
        pageId: _selectedPageId!,
        order: 0, // Will be set when saving
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();

    widget.onSave(logos);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Multiple Logos',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedPageId?.isEmpty ?? true ? null : _selectedPageId,
                      decoration: InputDecoration(
                        labelText: 'Page *',
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
                    SizedBox(height: 20.h),
                    MultiImagePickerWidget(
                      label: 'Logo Images *',
                      initialBase64List: _selectedImages,
                      onImagesSelected: (images) {
                        setState(() {
                          _selectedImages = images;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    if (_selectedImages.isNotEmpty)
                      Container(
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
                                'Will add ${_selectedImages.length} logo${_selectedImages.length > 1 ? 's' : ''} to page: ${_pageNames[_selectedPageId] ?? _selectedPageId}',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
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
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4ED47),
                    foregroundColor: Colors.black,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Text('Add ${_selectedImages.isEmpty ? '' : '(${_selectedImages.length})'}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

