import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentBase64List = List<String>.from(widget.initialBase64List ?? []);
  }

  Future<void> _pickImages() async {
    try {
      if (kIsWeb) {
        // Use file_picker for web - allows multiple files
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
          allowMultiple: true, // Enable multiple selection
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
                content: Text('Added ${newBase64List.length} image(s)'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } else {
        // On mobile, show dialog to choose source, then pick multiple
        final source = await _showImageSourceDialog();
        if (source != null) {
          // For mobile, we'll pick one at a time but allow multiple selections
          _pickImageFromSource(source);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 4096, // Higher resolution for better quality
        maxHeight: 4096,
        imageQuality: 95, // Higher quality (95% instead of 85%)
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        
        setState(() {
          _currentBase64List.add(base64String);
        });
        
        widget.onImagesSelected(_currentBase64List);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image added'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    if (kIsWeb) {
      return ImageSource.gallery;
    }
    
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر مصدر الصورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('المعرض'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
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
                      ElevatedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('اختر صور'),
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
                      label: const Text('إضافة المزيد'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

