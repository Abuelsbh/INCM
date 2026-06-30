import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:incm/core/Content/content_provider.dart';
import 'package:incm/core/Content/route_page_mapping.dart';
import 'package:incm/core/Contact/contact_info_provider.dart';
import '../../Utilities/router_config.dart';
import 'splash_session.dart';

const Duration _kSplashLoadTimeout = Duration(seconds: 12);

/// Loads page data from Firebase and navigates when ready.
/// Call from splash screen initState after [SplashSession.beginSplashFrame].
Future<void> loadDataAndNavigate(BuildContext context, String targetRoute) async {
  final contentProvider = Provider.of<ContentProvider>(context, listen: false);
  final contactProvider = Provider.of<ContactInfoProvider>(context, listen: false);

  final pageId = RoutePageMapping.getPageIdForRoute(targetRoute);

  Future<void> loadData() async {
    final tasks = <Future<void>>[
      contactProvider.fetchContactInfo(),
      contentProvider.prefetchOtherContentPages(exceptPageId: pageId),
    ];

    if (pageId != null && !contentProvider.isPageCached(pageId)) {
      tasks.add(contentProvider.ensurePageLoaded(pageId));
    }

    await Future.wait(tasks);
  }

  try {
    await Future.wait<void>([
      loadData(),
      SplashSession.animationEnded,
    ]).timeout(_kSplashLoadTimeout);
  } on TimeoutException {
    SplashSession.completeAnimation();
  }

  SplashSession.markFirstSplashDone();
  GoRouterConfig.router.go(targetRoute);
}
