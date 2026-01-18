import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialBase64;
  final Function(String base64) onImageSelected;
  final String label;

  const ImagePickerWidget({
    super.key,
    this.initialBase64,
    required this.onImageSelected,
    required this.label,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _currentBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentBase64 = widget.initialBase64;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (kIsWeb) {
        // Use file_picker for web
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
          withData: true,
        );
        
        if (result != null && result.files.single.bytes != null) {
          final bytes = result.files.single.bytes!;
          final base64String = base64Encode(bytes);
          
          setState(() {
            _currentBase64 = base64String;
          });
          
          widget.onImageSelected(base64String);
        }
      } else {
        // Use image_picker for mobile
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 4096, // Higher resolution for better quality
          maxHeight: 4096,
          imageQuality: 95, // Higher quality (95% instead of 85%)
        );

        if (image != null) {
          final bytes = await image.readAsBytes();
          
          // Convert to base64
          final base64String = base64Encode(bytes);
          
          setState(() {
            _currentBase64 = base64String;
          });
          
          widget.onImageSelected(base64String);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    if (kIsWeb) {
      // On web, directly open file selector
      _pickImage(ImageSource.gallery);
    } else {
      // On mobile, show dialog to choose source
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('اختر مصدر الصورة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _currentBase64 != null && _currentBase64!.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Builder(
                        builder: (context) {
                          try {
                            String base64String = _currentBase64!.trim();
                            // Remove data URL prefix if present
                            if (base64String.contains(',')) {
                              base64String = base64String.split(',').last.trim();
                            }
                            final bytes = base64Decode(base64String);
                            return Image.memory(
                              bytes,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high, // High quality preview
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text('خطأ في تحميل الصورة'),
                                    ],
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  Text('خطأ: $e'),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _currentBase64 = null;
                          });
                          widget.onImageSelected('');
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('اختر صورة'),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

