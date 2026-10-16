import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'screens/app_shell.dart';
import 'screens/auth_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FastDeliciousFoodApp());
}

class FastDeliciousFoodApp extends StatefulWidget {
  const FastDeliciousFoodApp({super.key});

  @override
  State<FastDeliciousFoodApp> createState() => _FastDeliciousFoodAppState();
}

class _FastDeliciousFoodAppState extends State<FastDeliciousFoodApp> {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast and Delicious Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      // Only the home subtree listens to AppState; the MaterialApp itself
      // (theme, navigator) is built once per root rebuild.
      home: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return appState.isAuthenticated
              ? MainZoomDrawerShell(appState: appState)
              : AuthScreen(appState: appState);
        },
      ),
    );
  }
}
