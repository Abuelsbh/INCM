import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:incm/Modules/Buy/buy_screen.dart';
import 'package:incm/Modules/Career/career_screen.dart';
import 'package:incm/Modules/Lease/lease_screen.dart';
import 'package:incm/Modules/Sell/sell_screen.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Splash/splash_screen.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';
import '../Modules/Services/GenericService/generic_service_screen.dart';
import '../Modules/AllLogos/all_logos_screen.dart';
import '../Modules/Admin/admin_panel_screen.dart';
import '../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
import '../Modules/NativeApp/office_map_screen.dart';
import '../Modules/NativeApp/saved_bookmarks_screen.dart';
import '../core/Content/content_provider.dart';
import '../core/Content/route_page_mapping.dart';
import '../core/app_build_config.dart';

BuildContext? get currentContext_ =>
    GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;

class GoRouterConfig{
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    initialLocation: AppBuildConfig.isAdminApp
        ? AdminPanelScreen.routeName
        : SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          final target = state.queryParameters['target'] ?? '/';
          return getCustomTransitionPage(
            state: state,
            child: SplashScreen(targetRoute: target),
          );
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: ContactsScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ContactsScreen(),
          );
        },
      ),
      GoRoute(
        path: AboutScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const AboutScreen(),
          );
        },
      ),
      GoRoute(
        path: CareerScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const CareerScreen(),
          );
        },
      ),
      GoRoute(
        path: BuyScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const BuyScreen(),
          );
        },
      ),
      GoRoute(
        path: SellScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SellScreen(),
          );
        },
      ),
      GoRoute(
        path: LeaseScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const LeaseScreen(),
          );
        },
      ),
      GoRoute(
        path: ConsultationScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ConsultationScreen(),
          );
        },
      ),
      GoRoute(
        path: RetailLeasingScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const RetailLeasingScreen(),
          );
        },
      ),
      GoRoute(
        path: MedicalLeasingScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const MedicalLeasingScreen(),
          );
        },
      ),
      GoRoute(
        path: CorporateLeasingScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const CorporateLeasingScreen(),
          );
        },
      ),
      GoRoute(
        path: FacilityManagementScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const FacilityManagementScreen(),
          );
        },
      ),
      GoRoute(
        path: FranchiseInvestmentScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const FranchiseInvestmentScreen(),
          );
        },
      ),
      GoRoute(
        path: PrimaryInvestmentScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const PrimaryInvestmentScreen(),
          );
        },
      ),
      GoRoute(
        path: MarketingScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const MarketingScreen(),
          );
        },
      ),
      // Dynamic route for custom services (added from dashboard)
      GoRoute(
        path: '/services/:pageId',
        pageBuilder: (_, GoRouterState state) {
          final pageId = state.pathParameters['pageId'] ?? '';
          return getCustomTransitionPage(
            state: state,
            child: GenericServiceScreen(pageId: pageId),
          );
        },
      ),
      GoRoute(
        path: AllLogosScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const AllLogosScreen(),
          );
        },
      ),
      GoRoute(
        path: AdminPanelScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const AdminPanelScreen(),
          );
        },
      ),
      GoRoute(
        path: ExclusiveLeasingProjectsScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ExclusiveLeasingProjectsScreen(),
          );
        },
      ),
      GoRoute(
        path: OfficeMapScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const OfficeMapScreen(),
          );
        },
      ),
      GoRoute(
        path: SavedBookmarksScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SavedBookmarksScreen(),
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.location.split('?').first;
      if (location == SplashScreen.routeName) return null;

      // Admin and non-content routes: no redirect
      if (!RoutePageMapping.isContentRoute(location)) return null;

      final pageId = RoutePageMapping.getPageIdForRoute(location);
      if (pageId == null) return null;

      try {
        final contentProvider = Provider.of<ContentProvider>(context, listen: false);
        if (contentProvider.isPageCached(pageId)) return null;
      } catch (_) {
        return null; // Provider not ready yet
      }

      // Redirect to splash to load data, then come back
      final target = state.location;
      return '${SplashScreen.routeName}?target=${Uri.encodeComponent(target)}';
    },
  );

  static CustomTransitionPage getCustomTransitionPage({required GoRouterState state, required Widget child}){
    return CustomTransitionPage(
      key: state.pageKey,
      child: SelectionArea(child: child),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}





