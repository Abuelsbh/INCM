import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:incm/core/Content/content_provider.dart';
import 'package:incm/core/Content/route_page_mapping.dart';
import 'package:incm/core/Contact/contact_info_provider.dart';
import '../../Utilities/router_config.dart';

/// Loads page data from Firebase and navigates when ready.
/// Call from splash screen initState.
Future<void> loadDataAndNavigate(BuildContext context, String targetRoute) async {
  final contentProvider = Provider.of<ContentProvider>(context, listen: false);
  final contactProvider = Provider.of<ContactInfoProvider>(context, listen: false);

  final pageId = RoutePageMapping.getPageIdForRoute(targetRoute);

  // Load page content from Firebase
  if (pageId != null && !contentProvider.isPageCached(pageId)) {
    await contentProvider.ensurePageLoaded(pageId);
  }

  // For home page, also load contact info
  if (targetRoute == '/' || targetRoute.isEmpty) {
    await contactProvider.fetchContactInfo();
  }

  if (!context.mounted) return;
  GoRouterConfig.router.go(targetRoute);
}
