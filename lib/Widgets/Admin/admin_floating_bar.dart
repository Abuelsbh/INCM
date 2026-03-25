import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/Admin/admin_mode_provider.dart';
import '../../core/Language/locales.dart';
import '../../Modules/Admin/admin_panel_screen.dart';

/// Floating bar shown only when in admin mode. Does not affect user layout.
class AdminFloatingBar extends StatelessWidget {
  const AdminFloatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminModeProvider>(
      builder: (context, adminProvider, _) {
        if (!adminProvider.isAdminMode) return const SizedBox.shrink();

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.black.withOpacity(0.9),
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings,
                        color: const Color(0xFFF4ED47), size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'ADMIN_PANEL'.tr(context),
                      style: TextStyle(
                        color: const Color(0xFFF4ED47),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () =>
                          context.go(AdminPanelScreen.routeName),
                      icon: Icon(Icons.business, size: 18.sp, color: Colors.white70),
                      label: Text(
                        'TAB_LOGOS'.tr(context),
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          context.go(AdminPanelScreen.routeName),
                      icon: Icon(Icons.contact_phone, size: 18.sp, color: Colors.white70),
                      label: Text(
                        'TAB_CONTACT_INFO'.tr(context),
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Material(
                      color: const Color(0xFFF4ED47).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                      child: InkWell(
                        onTap: () => adminProvider.exitAdminMode(),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          child: Text(
                            'EXIT_ADMIN'.tr(context),
                            style: TextStyle(
                              color: const Color(0xFFF4ED47),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
