import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/Language/locales.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialBase64;
  final void Function(String base64) onImageSelected;
  final String label;
  /// When false, taps are ignored (e.g. while parent dialog is saving).
  final bool enabled;

  const ImagePickerWidget({
    super.key,
    this.initialBase64,
    required this.onImageSelected,
    required this.label,
    this.enabled = true,
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

  @override
  void didUpdateWidget(ImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialBase64 != oldWidget.initialBase64) {
      _currentBase64 = widget.initialBase64;
    }
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
          SnackBar(content: Text('ERROR_PICKING_IMAGE'.tr(context).replaceAll('{error}', e.toString()))),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    if (!widget.enabled) return;
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
    final canTap = widget.enabled;
    final hasImage = _currentBase64 != null && _currentBase64!.trim().isNotEmpty;

    Widget previewChild;
    if (hasImage) {
      previewChild = Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Builder(
              builder: (context) {
                try {
                  String base64String = _currentBase64!.trim();
                  if (base64String.contains(',')) {
                    base64String = base64String.split(',').last.trim();
                  }
                  final bytes = base64Decode(base64String);
                  return Image.memory(
                    bytes,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
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
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: canTap
                    ? () {
                        setState(() {
                          _currentBase64 = null;
                        });
                        widget.onImageSelected('');
                      }
                    : null,
              ),
            ),
          ),
        ],
      );
    } else {
      previewChild = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 40, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'اضغط هنا أو على الزر لاختيار صورة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: canTap ? _showImageSourceDialog : null,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('اختر صورة'),
          ),
        ],
      );
    }

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
        Material(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: canTap ? _showImageSourceDialog : null,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: previewChild,
            ),
          ),
        ),
      ],
    );
  }
}

