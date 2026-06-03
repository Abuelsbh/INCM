import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:incm/core/Content/content_provider.dart';
import 'package:incm/core/Content/route_page_mapping.dart';
import 'package:incm/core/Contact/contact_info_provider.dart';
import '../../Utilities/router_config.dart';
import 'splash_session.dart';

/// Loads page data from Firebase and navigates when ready.
/// Call from splash screen initState after [SplashSession.beginSplashFrame].
Future<void> loadDataAndNavigate(BuildContext context, String targetRoute) async {
  final contentProvider = Provider.of<ContentProvider>(context, listen: false);
  final contactProvider = Provider.of<ContactInfoProvider>(context, listen: false);

  final pageId = RoutePageMapping.getPageIdForRoute(targetRoute);

  Future<void> loadData() async {
    if (pageId != null && !contentProvider.isPageCached(pageId)) {
      await contentProvider.ensurePageLoaded(pageId);
    }

    // دائماً: إعدادات الاتصال وEmailJS من لوحة الأدمن (Firestore) — الموبايل يعتمد عليها
    // وليس على --dart-define كالويب.
    await contactProvider.fetchContactInfo();
  }

  await Future.wait<void>([
    loadData(),
    SplashSession.animationEnded,
  ]);

  if (!context.mounted) return;
  GoRouterConfig.router.go(targetRoute);
  SplashSession.markFirstSplashDone();
  unawaited(
    contentProvider.prefetchOtherContentPages(exceptPageId: pageId),
  );
}
