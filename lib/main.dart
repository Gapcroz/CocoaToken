import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './controllers/profile_controller.dart';
import './controllers/auth_controller.dart';
import './controllers/token_controller.dart';
import './controllers/coupon_controller.dart';
import './services/auth_service.dart';
import './providers/navigation_provider.dart';
import './providers/bottom_navigation_provider.dart';
import './theme/app_theme.dart';
import './layouts/main_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System optimizations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Clear any persistent data when starting the app
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Run a minimal app first
  runApp(const MinimalApp());

  // Initialize in background
  Future.delayed(const Duration(milliseconds: 300), _initializeAppAsync);
}

Future<void> _initializeAppAsync() async {
  try {
    await AuthService.init();
    final authController = AuthController();
    await authController.init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider.value(value: authController),
          ChangeNotifierProvider(create: (_) => TokenController()),
          ChangeNotifierProvider(create: (_) => CouponController()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Error initializing app: $e');
    runApp(const MyApp());
  }
}

class MinimalApp extends StatelessWidget {
  const MinimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: const Color(0xFF111827),
        child: const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocoa Token',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorKey: ProfileController.navigatorKey,
      home: const MainLayout(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés
      ],
    );
  }
}
