import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../core/Content/content_helper.dart';
import '../core/Content/content_provider.dart';
import '../Models/content_model.dart';
import 'base64_image_widget.dart';

// Import File only for non-web platforms
import 'dart:io' if (dart.library.html) 'dart:html' as html;

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
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final height = isDesktop ? 1200.0 : 786.0;

    // Use Consumer to listen to ContentProvider changes
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        return FutureBuilder<ContentModel?>(
          // Clear cache and reload when provider notifies
          future: contentProvider.getContent('home', 'home-media-section'),
          builder: (context, snapshot) {
            // Show loading while fetching
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            // Don't show if no content from admin panel
            if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox.shrink();
            }

            final content = snapshot.data!;
            final contentType = content.type;

            // Check if content has changed
            final contentChanged = _lastContentId != content.id;
            if (contentChanged) {
              _lastContentId = content.id;
              // Dispose old video controller if content changed
              if (_videoController != null) {
                _videoController?.dispose();
                _videoController = null;
                _isVideoInitialized = false;
                _isInitializing = false;
              }
            }

            // Initialize video if needed (using WidgetsBinding to avoid calling in build)
            if (contentType == ContentType.video && _videoController == null && !_isInitializing) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeVideo(content);
              });
            }

            return Container(
              width: double.infinity,
              height: height.h,
              child: _buildMedia(contentType),
            );
          },
        );
      },
    );
  }

  Widget _buildMedia(ContentType contentType) {
    if (contentType == ContentType.video) {
      return _buildVideo();
    } else if (contentType == ContentType.image) {
      return _buildImage();
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideo() {
    if (_videoController == null || !_isVideoInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
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

  Widget _buildImage() {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        return FutureBuilder<Widget>(
          future: ContentHelper.getImage(
            context,
            'home',
            'home-media-section',
            width: double.infinity,
            height: null,
            fit: BoxFit.cover,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
