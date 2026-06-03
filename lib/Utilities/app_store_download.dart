import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/Language/locales.dart';
import 'font_helper.dart';

/// Listing URLs for the published INCM mobile apps.
abstract final class AppStoreUrls {
  static const googlePlay =
      'https://play.google.com/store/apps/details?id=com.incomercial.realestate';
  static const appStore = 'https://apps.apple.com/eg/app/incm/id6762870777';
}

Future<void> launchAppListing(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Picks Google Play or App Store (used from GET APP on web / narrow layouts).
Future<void> showAppDownloadSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF1a1a1a),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'DOWNLOAD_APP_SHEET_TITLE'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                  color: const Color(0xFFF4ED47),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              _storeButton(
                context,
                label: 'GOOGLE_PLAY'.tr(context),
                onTap: () async {
                  Navigator.pop(ctx);
                  await launchAppListing(AppStoreUrls.googlePlay);
                },
              ),
              SizedBox(height: 12.h),
              _storeButton(
                context,
                label: 'APP_STORE'.tr(context),
                onTap: () async {
                  Navigator.pop(ctx);
                  await launchAppListing(AppStoreUrls.appStore);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _storeButton(
  BuildContext context, {
  required String label,
  required VoidCallback onTap,
}) {
  return Material(
    color: const Color(0xFFF4ED47),
    borderRadius: BorderRadius.circular(10.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: getLocalizedFont(context, 'OptimalBold'),
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}
