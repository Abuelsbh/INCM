import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../core/Content/content_provider.dart';
import '../Models/content_model.dart';

/// Widget to display image or video after HomeSearchSection
/// Only shows if content is added from admin panel
class HomeMediaSection extends StatefulWidget {
  const HomeMediaSection({super.key});

  @override
  State<HomeMediaSection> createState() => _HomeMediaSectionState();
}

class _HomeMediaSectionState extends State<HomeMediaSection> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isInitializing = false;
  dynamic _tempVideoFile; // File on mobile, null on web (using dynamic to avoid web issues)
  String? _lastContentId; // Track content ID to detect changes
  late final Future<List<ContentModel>> _homeContentFuture;

  @override
  void initState() {
    super.initState();
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    _homeContentFuture = contentProvider.getPageContent('home');
  }

  Future<void> _initializeVideo(ContentModel content) async {
    if (_isInitializing || _videoController != null) return;
    
    setState(() {
      _isInitializing = true;
    });

    try {
      VideoPlayerController? controller;
      
      // Check if video is base64 or link
      if (content.imageBase64 != null && content.imageBase64!.isNotEmpty) {
        // Base64 video - need to save to temp file first (not supported on web)
        if (kIsWeb) {
          // On web, base64 videos are not easily supported by video_player
          // Recommend using a link URL instead
          if (kDebugMode) {
            print('Base64 videos are not supported on web. Please use a video URL link instead.');
          }
        } else {
          // Only on mobile platforms (not web)
          try {
            final bytes = base64Decode(content.imageBase64!);
            
            // Get temporary directory
            final tempDir = await getTemporaryDirectory();
            // Create File only on non-web platforms
            final tempFile = File('${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4');
            
            // Write bytes to file
            await tempFile.writeAsBytes(bytes);
            
            // Store reference to temp file for cleanup
            _tempVideoFile = tempFile;
            
            // Create controller from file
            controller = VideoPlayerController.file(tempFile);
          } catch (e) {
            if (kDebugMode) {
              print('Error decoding base64 video: $e');
            }
          }
        }
      } else if (content.values['link'] != null && content.values['link']!.isNotEmpty) {
        // Link video
        controller = VideoPlayerController.networkUrl(
          Uri.parse(content.values['link']!),
        );
      }

      if (controller != null) {
        await controller.initialize();
        controller.setLooping(true);
        controller.setVolume(0.0);
        await controller.play();
        
        if (mounted) {
          setState(() {
            _videoController = controller;
            _isVideoInitialized = true;
            _isInitializing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    // Clean up temporary file if it exists (only on mobile)
    if (!kIsWeb && _tempVideoFile != null) {
      try {
        // Only delete if it's a File (not web)
        if (_tempVideoFile is File) {
          (_tempVideoFile as File).delete().catchError((e) {
            if (kDebugMode) {
              print('Error deleting temp video file: $e');
            }
            return _tempVideoFile;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error accessing temp video file: $e');
        }
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    const sectionId = 'home-media-section';

    return FutureBuilder<List<ContentModel>>(
      future: _homeContentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final list = snapshot.data ?? [];
        ContentModel? content;
        for (final c in list) {
          if (c.sectionId == sectionId) {
            content = c;
            break;
          }
        }
        if (content == null) {
          return const SizedBox.shrink();
        }

        final contentType = content.type;

        // لو الصورة/الفيديو مش هينعرض — ما نعرضش أي حاجة من البداية
        final hasValidImage = contentType == ContentType.image &&
            ((content.imageBase64 != null && content.imageBase64!.trim().isNotEmpty) ||
                (content.values['link'] != null &&
                    content.values['link']!.trim().isNotEmpty));
        final hasValidVideo = contentType == ContentType.video &&
            ((content.imageBase64 != null && content.imageBase64!.trim().isNotEmpty) ||
                (content.values['link'] != null &&
                    content.values['link']!.trim().isNotEmpty));
        if (contentType == ContentType.image && !hasValidImage) {
          return const SizedBox.shrink();
        }
        if (contentType == ContentType.video && !hasValidVideo) {
          return const SizedBox.shrink();
        }

        // Check if content has changed within this page instance only
        final contentChanged = _lastContentId != content.id;
        if (contentChanged) {
          _lastContentId = content.id;
          if (_videoController != null) {
            _videoController?.dispose();
            _videoController = null;
            _isVideoInitialized = false;
            _isInitializing = false;
          }
        }

        if (contentType == ContentType.video &&
            _videoController == null &&
            !_isInitializing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeVideo(content!);
          });
        }

        // للفيديو: ما نعرضش القسم غير لما الفيديو يكون جاهز (ما نعرضش loading أو خلفية)
        if (contentType == ContentType.video) {
          if (_videoController == null || !_isVideoInitialized) {
            return const SizedBox.shrink();
          }
        }

        return RepaintBoundary(
          child: SizedBox(
            width: width,
            height: height,
            child: _buildMedia(contentType, content),
          ),
        );
      },
    );
  }

  Widget _buildMedia(ContentType contentType, ContentModel content) {
    if (contentType == ContentType.video) {
      return _buildVideo();
    } else if (contentType == ContentType.image) {
      return _buildImage(content);
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideo() {
    if (_videoController == null || !_isVideoInitialized) {
      return const SizedBox.shrink();
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _videoController!.value.size.width,
        height: _videoController!.value.size.height,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  Widget _buildImage(ContentModel content) {
    final link = content.values['link']?.trim();
    if (link != null && link.isNotEmpty) {
      return Image.network(
        link,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const SizedBox.shrink();
        },
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    final base64 = content.imageBase64?.trim();
    if (base64 == null || base64.isEmpty) {
      return const SizedBox.shrink();
    }
    String cleanBase64 = base64;
    if (cleanBase64.startsWith('data:image')) {
      final parts = cleanBase64.split(',');
      if (parts.length == 2) cleanBase64 = parts[1].trim();
    }
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s'), '');
    if (cleanBase64.isEmpty) return const SizedBox.shrink();

    try {
      final bytes = base64Decode(cleanBase64);
      if (bytes.isEmpty) return const SizedBox.shrink();
      return Image.memory(
        bytes,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}
