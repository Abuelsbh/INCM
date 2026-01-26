import 'package:flutter/foundation.dart';
import '../../Models/content_model.dart';
import '../../Models/page_content_model.dart';
import '../Firebase/firebase_content_service.dart';

class ContentProvider extends ChangeNotifier {
  final FirebaseContentService _contentService = FirebaseContentService();

  // Cache for content
  final Map<String, List<ContentModel>> _contentCache = {};
  final Map<String, ContentModel> _singleContentCache = {};
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get content for a specific page
  Future<List<ContentModel>> getPageContent(String pageId) async {
    // Check cache first
    if (_contentCache.containsKey(pageId)) {
      return _contentCache[pageId]!;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final content = await _contentService.getPageContent(pageId);
      _contentCache[pageId] = content;
      _isLoading = false;
      notifyListeners();
      return content;
    } catch (e) {
      _errorMessage = 'Error loading content: $e';
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// Get specific content by page and section
  Future<ContentModel?> getContent(String pageId, String sectionId) async {
    final cacheKey = '$pageId-$sectionId';
    
    // Check cache first
    if (_singleContentCache.containsKey(cacheKey)) {
      return _singleContentCache[cacheKey];
    }

    try {
      final content = await _contentService.getContent(pageId, sectionId);
      if (content != null) {
        _singleContentCache[cacheKey] = content;
      }
      return content;
    } catch (e) {
      _errorMessage = 'Error loading content: $e';
      // Don't notify listeners for cache misses - only notify on actual errors that need UI updates
      return null;
    }
  }

  /// Get text content in specific language
  Future<String> getTextContent(
    String pageId,
    String sectionId,
    String language, {
    String defaultValue = '',
  }) async {
    final content = await getContent(pageId, sectionId);
    if (content != null && content.type == ContentType.text) {
      return content.values[language] ?? defaultValue;
    }
    return defaultValue;
  }

  /// Get image content as base64
  Future<String?> getImageContent(String pageId, String sectionId) async {
    final content = await getContent(pageId, sectionId);
    if (content != null) {
      // Check if it's explicitly an image type
      if (content.type == ContentType.image) {
        return content.imageBase64;
      }
      // Also check if sectionId suggests it's an image/logo and has base64 data
      // This handles cases where content was saved with wrong type
      if ((sectionId.contains('image') || sectionId.contains('logo')) &&
          content.imageBase64 != null &&
          content.imageBase64!.isNotEmpty) {
        return content.imageBase64;
      }
    }
    return null;
  }

  /// Get video content (base64 or link)
  Future<Map<String, String?>?> getVideoContent(String pageId, String sectionId) async {
    final content = await getContent(pageId, sectionId);
    if (content != null && content.type == ContentType.video) {
      return {
        'base64': content.imageBase64, // Video can be stored as base64
        'link': content.values['link'], // Or as a link URL
      };
    }
    return null;
  }

  /// Save or update content
  Future<bool> saveContent(ContentModel content) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _contentService.saveContent(content);
      
      if (success) {
        // Clear cache for this specific content to force reload
        final cacheKey = '${content.pageId}-${content.sectionId}';
        _singleContentCache.remove(cacheKey);
        
        // Clear page cache to ensure fresh data
        _contentCache.remove(content.pageId);

        // Reload the specific content from Firebase to get the latest data (including new ID if it was created)
        final updatedContent = await _contentService.getContent(content.pageId, content.sectionId);
        
        if (updatedContent != null) {
          // Update single content cache with fresh data
          _singleContentCache[cacheKey] = updatedContent;
          
          // Reload page content to update the page cache
          await getPageContent(content.pageId);
        }
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Error saving content: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete content
  Future<bool> deleteContent(String contentId, String pageId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _contentService.deleteContent(contentId);
      
      if (success) {
        // Remove from cache
        if (_contentCache.containsKey(pageId)) {
          _contentCache[pageId]!.removeWhere((c) => c.id == contentId);
        }
        _singleContentCache.removeWhere((key, value) => value.id == contentId);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Error deleting content: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get all pages content
  Future<List<PageContentModel>> getAllPagesContent() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pages = await _contentService.getAllPagesContent();
      
      // Update cache
      for (var page in pages) {
        _contentCache[page.pageId] = page.contents;
      }

      _isLoading = false;
      notifyListeners();
      return pages;
    } catch (e) {
      _errorMessage = 'Error loading pages: $e';
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// Clear cache
  void clearCache() {
    _contentCache.clear();
    _singleContentCache.clear();
    notifyListeners();
  }

  /// Clear cache for specific page
  void clearPageCache(String pageId) {
    _contentCache.remove(pageId);
    _singleContentCache.removeWhere((key, value) => value.pageId == pageId);
    notifyListeners();
  }
}

