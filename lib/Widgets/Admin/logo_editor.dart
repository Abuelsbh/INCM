import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/logo_model.dart';
import 'image_picker_widget.dart';
import 'text_editor_widget.dart';

class LogoEditor extends StatefulWidget {
  final LogoModel? initialLogo;
  final Function(LogoModel) onSave;
  final VoidCallback? onCancel;

  const LogoEditor({
    super.key,
    this.initialLogo,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<LogoEditor> createState() => _LogoEditorState();
}

class _LogoEditorState extends State<LogoEditor> {
  late TextEditingController _nameController;
  String? _imageBase64;
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
    _imageBase64 = logo?.imageBase64;
    _selectedPageId = logo?.pageId ?? '';
    _order = logo?.order ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_imageBase64 == null || _imageBase64!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image for the logo')),
      );
      return;
    }

    if (_selectedPageId == null || _selectedPageId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a page')),
      );
      return;
    }

    final logo = LogoModel(
      id: widget.initialLogo?.id ?? '',
      name: _nameController.text.trim(),
      imageBase64: _imageBase64!,
      pageId: _selectedPageId!,
      order: _order,
      createdAt: widget.initialLogo?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(logo);
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
                        ? 'Add New Logo'
                        : 'Edit Logo',
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
              SizedBox(height: 16.h),
              TextEditorWidget(
                label: 'Logo Name (optional)',
                initialValue: _nameController.text,
                onChanged: (value) => _nameController.text = value,
              ),
              SizedBox(height: 16.h),
              ImagePickerWidget(
                label: 'Logo Image *',
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
                    onPressed: widget.onCancel ?? () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
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

