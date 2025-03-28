import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './controllers/profile_controller.dart';
import './controllers/auth_controller.dart';
import './controllers/token_controller.dart';
import './controllers/coupon_controller.dart';
import './layouts/main_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './controllers/store_controller.dart';
import './controllers/events_controller.dart';
import './services/initialization_service.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimizaciones de rendimiento
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  // Configurar el ImageCache
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          // Optimizar el comportamiento del scroll
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const BouncingScrollPhysics(),
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          child: child!,
        );
      },
      home: const InitialLoadingScreen(),
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Usar un microtask para no bloquear el hilo principal
    Future.microtask(() => _initializeApp());
  }

  Future<void> _initializeApp() async {
    try {
      // Agregar un pequeño delay para permitir que el frame se renderice
      await Future.delayed(const Duration(milliseconds: 100));
      await InitializationService.initialize();

      if (!mounted) return;

      // Usar pushAndRemoveUntil para limpiar la pila de navegación
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const MainAppWidget(),
          transitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error durante la inicialización: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF111827),
      body: Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Solo AuthController sin lazy loading
        ChangeNotifierProvider(create: (_) => AuthController(), lazy: false),
        // El resto con lazy loading estricto
        ...[
          // Usar spread operator para cargar estos providers después
          ChangeNotifierProvider(create: (_) => TokenController(), lazy: true),
          ChangeNotifierProvider(create: (_) => StoreController(), lazy: true),
          ChangeNotifierProvider(create: (_) => CouponController(), lazy: true),
          Provider(
            create: (_) => EventsController(),
            lazy: true,
            dispose: (_, controller) => controller.dispose(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileController(),
            lazy: true,
          ),
        ],
      ],
      child: MaterialApp(
        title: 'Cocoa Token',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const MainLayout(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es'), Locale('en')],
      ),
    );
  }
}
