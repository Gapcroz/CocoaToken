import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'layouts/main_layout.dart';
import 'screens/login_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/coupons_screen.dart';
import 'screens/stores_screen.dart';
import 'controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize authentication state
  await AuthService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        navigatorKey: ProfileController.navigatorKey,
        title: 'CocoaToken',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E40AF),
            primary: const Color(0xFF1E40AF),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
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