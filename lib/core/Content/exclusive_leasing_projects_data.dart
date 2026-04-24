import '../../Models/content_model.dart';
import '../../generated/assets.dart';

/// Shared metadata and ordering for Exclusive Leasing Projects (CMS + public page).
class ExclusiveLeasingProjectsData {
  ExclusiveLeasingProjectsData._();

  static const String pageId = 'exclusive-leasing-projects';

  static const List<String> orderedSlugs = [
    'umc',
    'park-mall',
    'terrace',
    'point90',
    'kernel',
    'city-square',
    'vitali',
    'seashell',
  ];

  /// Parses project slug from a dashboard section id, or null if not part of this feature.
  static String? slugFromSectionId(String sectionId) {
    const titleSuffix = '-title';
    const descSuffix = '-description';
    const logoSuffix = '-logo';
    if (sectionId.endsWith(titleSuffix)) {
      return sectionId.substring(0, sectionId.length - titleSuffix.length);
    }
    if (sectionId.endsWith(descSuffix)) {
      return sectionId.substring(0, sectionId.length - descSuffix.length);
    }
    if (sectionId.endsWith(logoSuffix)) {
      return sectionId.substring(0, sectionId.length - logoSuffix.length);
    }
    final im = RegExp(r'^(.+)-image-\d+$').firstMatch(sectionId);
    return im?.group(1);
  }

  /// Slugs that appear in Firestore but are not in [orderedSlugs] (custom projects).
  static Set<String> discoverSlugsFromContents(List<ContentModel> contents) {
    final slugs = <String>{};
    for (final c in contents) {
      if (c.pageId != pageId) continue;
      final slug = slugFromSectionId(c.sectionId);
      if (slug != null && slug.isNotEmpty) {
        slugs.add(slug);
      }
    }
    return slugs;
  }

  /// Default order, then any extra slugs sorted lexicographically.
  static List<String> displayOrderSlugs(Set<String> extraFromFirebase) {
    final out = <String>[...orderedSlugs];
    final known = orderedSlugs.toSet();
    final extras = extraFromFirebase.difference(known).toList()..sort();
    out.addAll(extras);
    return out;
  }

  static String defaultDescriptionTrKeyForSlug(String slug) {
    switch (slug) {
      case 'umc':
        return 'EXCLUSIVE_LEASING_UMC_DESCRIPTION';
      case 'park-mall':
        return 'EXCLUSIVE_LEASING_PARK_MALL_DESCRIPTION';
      case 'terrace':
        return 'EXCLUSIVE_LEASING_TERRACE_DESCRIPTION';
      case 'point90':
        return 'EXCLUSIVE_LEASING_POINT90_DESCRIPTION';
      case 'kernel':
        return 'EXCLUSIVE_LEASING_KERNEL_DESCRIPTION';
      case 'city-square':
        return 'EXCLUSIVE_LEASING_CITY_SQUARE_DESCRIPTION';
      case 'vitali':
        return 'EXCLUSIVE_LEASING_VITALI_DESCRIPTION';
      case 'seashell':
        return 'EXCLUSIVE_LEASING_SEASHELL_DESCRIPTION';
      default:
        return '';
    }
  }

  static ExclusiveLeasingProjectSeed seedForSlug(String slug) {
    return _seeds[slug] ?? _fallbackSeed;
  }

  static final ExclusiveLeasingProjectSeed _fallbackSeed = ExclusiveLeasingProjectSeed(
    logoFallback: Assets.logosINCM,
    imageFallback: Assets.imagesLearnServices,
    localImages: const [],
    defaultTitleEn: 'PROJECT',
    defaultDescriptionTrKey: '',
  );

  static final Map<String, ExclusiveLeasingProjectSeed> _seeds = {
    'umc': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'UMC',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_UMC_DESCRIPTION',
    ),
    'park-mall': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'PARK MALL',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_PARK_MALL_DESCRIPTION',
    ),
    'terrace': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'TERRACE MALL',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_TERRACE_DESCRIPTION',
    ),
    'point90': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'POINT 90',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_POINT90_DESCRIPTION',
    ),
    'kernel': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'KERNEL',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_KERNEL_DESCRIPTION',
    ),
    'city-square': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'CITY SQUARE',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_CITY_SQUARE_DESCRIPTION',
    ),
    'vitali': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'VITALI',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_VITALI_DESCRIPTION',
    ),
    'seashell': ExclusiveLeasingProjectSeed(
      logoFallback: Assets.logosINCM,
      imageFallback: Assets.imagesLearnServices,
      localImages: const [],
      defaultTitleEn: 'SEASHELL',
      defaultDescriptionTrKey: 'EXCLUSIVE_LEASING_SEASHELL_DESCRIPTION',
    ),
  };
}

class ExclusiveLeasingProjectSeed {
  final String logoFallback;
  final String imageFallback;
  final List<String> localImages;
  final String defaultTitleEn;
  final String defaultDescriptionTrKey;

  const ExclusiveLeasingProjectSeed({
    required this.logoFallback,
    required this.imageFallback,
    required this.localImages,
    required this.defaultTitleEn,
    required this.defaultDescriptionTrKey,
  });

  Map<String, dynamic> toProjectRowMap(String id) {
    return {
      'id': id,
      'logoFallback': logoFallback,
      'imageFallback': imageFallback,
      'localImages': List<String>.from(localImages),
      'titleEn': defaultTitleEn,
      'titleAr': defaultTitleEn,
    };
  }
}
