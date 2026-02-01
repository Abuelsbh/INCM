import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/rush.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Utilities/fast_http_config.dart';
import 'Utilities/git_it.dart';
import 'Utilities/router_config.dart';
import 'Utilities/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'core/Font/font_provider.dart';
import 'core/Language/app_languages.dart';
import 'core/Language/locales.dart';
import 'core/Theme/theme_provider.dart';
import 'core/Content/content_provider.dart';
import 'core/Firebase/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    await Firebase.initializeApp(options: options);
  } on UnsupportedError catch (e) {
    // If Firebase initialization fails (e.g., missing Web App ID on web),
    // the app will still run but admin panel features won't work
    if (kDebugMode) {
      print('Firebase initialization skipped: $e');
      if (kIsWeb) {
        print('Note: For web, you need to add a Web App in Firebase Console and update firebase_options.dart');
        print('See FIREBASE_WEB_SETUP.md for instructions');
      }
    }
  } catch (e) {
    // Other Firebase errors
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
  }

  RushSetup.init(
    largeScreens: RushScreenSize.large,
    mediumScreens: RushScreenSize.medium,
    smallScreens: RushScreenSize.small,
    startMediumSize: 768,
    startLargeSize: 1200,
  );

  FastHttpConfig.init();

  await SharedPref.init();
  await GitIt.initGitIt();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppLanguage>(create: (_) => AppLanguage()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<FontProvider>(create: (_) => FontProvider()),
          ChangeNotifierProvider<ContentProvider>(create: (_) => ContentProvider()),
        ],
        child: const EntryPoint(),
      )
  );
}


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Initialize providers once
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appLan = Provider.of<AppLanguage>(context, listen: false);
        final appTheme = Provider.of<ThemeProvider>(context, listen: false);
        appLan.fetchLocale();
        appTheme.fetchTheme();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to changes
    return Consumer2<AppLanguage, ThemeProvider>(
      builder: (context, appLan, appTheme, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ScreenUtilInit(
              designSize: RushSetup.getSize(
                maxWidth: constraints.maxWidth,
                largeSize: const Size(1920,1080),
                mediumSize: const Size(1000,780),
                smallSize: const Size(375,812),
              ),
              builder:(_,__)=> MaterialApp.router(
                scrollBehavior: const MyCustomScrollBehavior(),
                routerConfig: GoRouterConfig.router,
                debugShowCheckedModeBanner: false,
                title: 'INCOMERCIAL',
                locale: Locale(appLan.appLang.name),
                theme: appTheme.appThemeMode,
                supportedLocales: Languages.values.map((e) => Locale(e.name)).toList(),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  DefaultMaterialLocalizations.delegate
                ],
                builder: (context, child) {
                  return Directionality(
                    textDirection: appLan.appLang == Languages.ar 
                        ? TextDirection.rtl 
                        : TextDirection.ltr,
                    child: child!,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  const MyCustomScrollBehavior();
  
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
