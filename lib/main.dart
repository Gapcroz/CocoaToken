import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'layouts/main_layout.dart';
import 'screens/login_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/coupons_screen.dart';
import 'screens/stores_screen.dart';
import 'controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/token_controller.dart';
import 'controllers/coupon_controller.dart';
import 'services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // This must be first
  WidgetsFlutterBinding.ensureInitialized();
  
  // System optimizations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Optimize display
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
  Future.delayed(const Duration(milliseconds: 300), () {
    _initializeAppAsync();
  });
}

// Function to initialize the app asynchronously
Future<void> _initializeAppAsync() async {
  try {
    // Initialize services in background
    await AuthService.init();
    
    // Load the real app when everything is ready
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => TokenController()),
          ChangeNotifierProvider(create: (_) => CouponController()),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    // In case of error, continue showing the app
    runApp(const MyApp());
  }
}

// Extremely simple minimal app
class MinimalApp extends StatelessWidget {
  const MinimalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The simplest possible app to avoid any loading
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TokenController()),
        ChangeNotifierProvider(create: (_) => CouponController()),
      ],
      child: MaterialApp(
        title: 'CocoaToken',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF111827),
            primary: const Color(0xFF111827),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainLayout(),
          '/login': (context) => const LoginScreen(),
          '/rewards': (context) => const RewardsScreen(),
          '/coupons': (context) => const CouponsScreen(),
          '/stores': (context) => const StoresScreen(),
        },
      ),
    );
  }
}