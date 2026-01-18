import 'package:get_it/get_it.dart';

class GitIt {
  static final GetIt _getIt = GetIt.instance;
  
  static GetIt get instance => _getIt;
  
  static Future<void> initGitIt() async {
    // Initialize GetIt service locator
    // Register services here if needed
  }
}

