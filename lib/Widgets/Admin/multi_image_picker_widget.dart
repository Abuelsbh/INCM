import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class MultiImagePickerWidget extends StatefulWidget {
  final List<String>? initialBase64List;
  final Function(List<String> base64List) onImagesSelected;
  final String label;

  const MultiImagePickerWidget({
    super.key,
    this.initialBase64List,
    required this.onImagesSelected,
    required this.label,
  });

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  List<String> _currentBase64List = [];

  @override
  void initState() {
    super.initState();
    _currentBase64List = List<String>.from(widget.initialBase64List ?? []);
  }

  Future<void> _pickImages() async {
    try {
      // Use file_picker for both web and mobile - allows multiple files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
        allowMultiple: true, // Enable multiple selection on all platforms
        withData: true,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final newBase64List = <String>[];
        
        for (var file in result.files) {
          if (file.bytes != null) {
            final base64String = base64Encode(file.bytes!);
            newBase64List.add(base64String);
          }
        }
        
        setState(() {
          _currentBase64List.addAll(newBase64List);
        });
        
        widget.onImagesSelected(_currentBase64List);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة ${newBase64List.length} صورة'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصور: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  void _removeImage(int index) {
    setState(() {
      _currentBase64List.removeAt(index);
    });
    widget.onImagesSelected(_currentBase64List);
  }

  Widget _buildImagePreview(String base64String, int index) {
    try {
      String cleanBase64 = base64String.trim();
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last.trim();
      }
      final bytes = base64Decode(cleanBase64);
      
      return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                bytes,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high, // High quality preview
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_currentBase64List.isNotEmpty)
              Text(
                '(${_currentBase64List.length} صورة)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _currentBase64List.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_library, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'يمكنك اختيار عدة صور في وقت واحد',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('اختر صور متعددة'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: List.generate(
                        _currentBase64List.length,
                        (index) => _buildImagePreview(_currentBase64List[index], index),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('إضافة المزيد من الصور'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

