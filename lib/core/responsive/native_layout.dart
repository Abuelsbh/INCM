import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Native iOS / Android (non-web) phone and tablet: use [BottomNavBarWidget] in
/// each screen instead of the marketing website [FooterSection] / [FooterSectionMob].
/// Include all iPhone sizes and iPad (incl. 12.9" Pro landscape, ~1366 logical width).
const double kNativeBottomNavLayoutMaxWidth = 1400;

bool useNativeBottomNavigationBar(BuildContext context) {
  return !kIsWeb &&
      MediaQuery.sizeOf(context).width < kNativeBottomNavLayoutMaxWidth;
}

/// [CustomAppBar] (wide web marketing header) only in the browser at ≥600pt.
/// [CustomAppBarMob] on mobile web, and on **all** native iOS/Android sizes
/// (phone + tablet) so the app shell never mimics the marketing site top bar.
bool useWebDesktopAppBar(BuildContext context) {
  return kIsWeb && MediaQuery.sizeOf(context).width >= 600;
}
