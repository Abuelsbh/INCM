import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../core/Content/exclusive_leasing_projects_data.dart';
import '../../core/Language/locales.dart';
import '../../core/NativeApp/saved_bookmarks_provider.dart';
import '../../core/responsive/native_layout.dart';
import '../ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';

/// قائمة المشاريع المحفوظة محليًا على الجهاز.
class SavedBookmarksScreen extends StatelessWidget {
  static const String routeName = '/saved-bookmarks';

  const SavedBookmarksScreen({super.key});

  String _titleForSlug(String slug, BuildContext context) {
    final seed = ExclusiveLeasingProjectsData.seedForSlug(slug);
    return seed.defaultTitleEn;
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF1a1a1a);
    final showNativeChrome = useNativeBottomNavigationBar(context);

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: showNativeChrome
          ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts)
          : null,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: useWebDesktopAppBar(context)
                    ? 16.h
                    : 50.h + 8.h,
              ),
              child: Consumer<SavedBookmarksProvider>(
                builder: (context, bookmarks, _) {
                  final slugs = bookmarks.orderedSavedSlugs;
                  if (slugs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            color: const Color(0xFFF4ED47),
                            size: 56.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'NATIVE_SAVED_EMPTY_TITLE'.tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'NATIVE_SAVED_EMPTY_HINT'.tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF4ED47),
                              foregroundColor: Colors.black87,
                            ),
                            onPressed: () =>
                                context.go(ExclusiveLeasingProjectsScreen.routeName),
                            child: Text('NATIVE_SAVED_GO_PROJECTS'.tr(context)),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NATIVE_SAVED_SCREEN_TITLE'.tr(context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'NATIVE_SAVED_SCREEN_SUBTITLE'.tr(context),
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: slugs.length,
                          separatorBuilder: (_, __) =>
                              Divider(color: Colors.white.withOpacity(0.12)),
                          itemBuilder: (context, i) {
                            final slug = slugs[i];
                            final title = _titleForSlug(slug, context);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                slug,
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12.sp,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: const Color(0xFFF4ED47),
                                onPressed: () async {
                                  await bookmarks.removeProject(slug);
                                  HapticFeedback.mediumImpact();
                                },
                              ),
                              onTap: () {
                                context.push(
                                  '${ExclusiveLeasingProjectsScreen.routeName}?projectId=${Uri.encodeComponent(slug)}',
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: useWebDesktopAppBar(context)
                ? const SizedBox.shrink()
                : SafeArea(bottom: false, child: SizedBox(height: 50.h, child: CustomAppBarMob())),
          ),
          if (showNativeChrome) const FloatingContactButtons(),
        ],
      ),
    );
  }
}
