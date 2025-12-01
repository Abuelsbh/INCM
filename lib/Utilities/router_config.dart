import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incm/Modules/Buy/buy_screen.dart';
import 'package:incm/Modules/Career/career_screen.dart';
import 'package:incm/Modules/Lease/lease_screen.dart';
import 'package:incm/Modules/Sell/sell_screen.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Splash/splash_screen.dart';

BuildContext? get currentContext_ =>
    GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;

class GoRouterConfig{
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: ContactsScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: ContactsScreen(),
          );
        },
      ),
      GoRoute(
        path: AboutScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: AboutScreen(),
          );
        },
      ),
      GoRoute(
        path: CareerScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: CareerScreen(),
          );
        },
      ),
      GoRoute(
        path: BuyScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: BuyScreen(),
          );
        },
      ),
      GoRoute(
        path: SellScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: SellScreen(),
          );
        },
      ),
      GoRoute(
        path: LeaseScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: LeaseScreen(),
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      return null; // No redirects needed for single page app
    },
  );

  static CustomTransitionPage getCustomTransitionPage({required GoRouterState state, required Widget child}){
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
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





