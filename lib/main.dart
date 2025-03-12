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
  // Esto debe ser lo primero
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimizaciones del sistema
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Optimizar la visualización
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Limpiar cualquier dato persistente al iniciar la app
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  // Ejecutar primero una app mínima
  runApp(const MinimalApp());
  
  // Inicializar en segundo plano
  Future.delayed(const Duration(milliseconds: 300), () {
    _initializeAppAsync();
  });
}

// Función para inicializar la app de forma asíncrona
Future<void> _initializeAppAsync() async {
  try {
    // Inicializar servicios en segundo plano
    await AuthService.init();
    
    // Cargar la app real cuando todo esté listo
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
    // En caso de error, seguir mostrando la app
    runApp(const MyApp());
  }
}

// App mínima extremadamente simple
class MinimalApp extends StatelessWidget {
  const MinimalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // La app más simple posible para evitar cualquier carga
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