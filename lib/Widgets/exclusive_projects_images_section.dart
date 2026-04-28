import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../core/Language/locales.dart';
import 'dynamic_content_widget.dart';
import '../generated/assets.dart';
import '../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
import '../Utilities/font_helper.dart';
import 'custom_button.dart';

/// Section displaying exclusive project images on the home page.
/// Uses ContentHelper for Firebase images with local asset fallbacks.
class ExclusiveProjectsImagesSection extends StatelessWidget {
  final Color? titleColor;
  final Color? backgroundColor;
  final VoidCallback? onLearnMorePressed;

  const ExclusiveProjectsImagesSection({
    super.key,
    this.titleColor,
    this.backgroundColor,
    this.onLearnMorePressed,
  });

  static const List<Map<String, dynamic>> _projects = [
    {'id': 'umc', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'park-mall', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'terrace', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'point90', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'kernel', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'city-square', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'vitali', 'imageFallback': Assets.imagesLearnServices},
    {'id': 'seashell', 'imageFallback': Assets.imagesLearnServices},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final titleColor = this.titleColor ?? const Color(0xFFF4ED47);
    final bgColor = backgroundColor ?? Colors.grey[900]!.withOpacity(0.4);
    final imageWidth = isMobile ? 180.w : 320.w;
    final imageHeight = isMobile ? 120.h : 220.h;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 0.h : 30.h),
          child: Text(
            'OUR_EXCLUSIVE_PROJECTS'.tr(context).toUpperCase(),
            style: TextStyle(
              fontFamily: getLocalizedFont(context, 'OptimalBold'),
              color: titleColor,
              fontSize: isMobile ? 22.sp : 60.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gap(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8.h : 8.h,
            horizontal: isMobile ? 8.h : 20.w,
          ),
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(isMobile ? 24.r : 50.r),
          ),
          child: Column(
            children: [
              SizedBox(
                height: imageHeight + (isMobile ? 4.h : 16.h),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.w : 16.w),
                  itemCount: _projects.length,
                  separatorBuilder: (_, __) => SizedBox(width: isMobile ? 12.w : 24.w),
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    final projectId = project['id'] as String;
                    final fallbackImage = project['imageFallback'] as String;
                    final sectionId = '$projectId-image-0';

                    return GestureDetector(
                      onTap: () {
                        context.go(
                          '${ExclusiveLeasingProjectsScreen.routeName}?projectId=$projectId',
                        );
                      },
                      child: RepaintBoundary(
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: DynamicImage(
                              pageId: 'exclusive-leasing-projects',
                              sectionId: sectionId,
                              fallbackAssetPath: fallbackImage,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (onLearnMorePressed != null) ...[
          Gap(isMobile ? 20.h : 30.h),
          Center(
            child: isMobile
                ? ButtonStyles.learnMoreButtonMob(
                    context: context,
                    onPressed: onLearnMorePressed!,
                  )
                : ButtonStyles.learnMoreButton(
                    context: context,
                    onPressed: onLearnMorePressed!,
                  ),
          ),
        ],
      ],
    );
  }
}
