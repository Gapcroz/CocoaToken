import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './controllers/profile_controller.dart';
import './controllers/auth_controller.dart';
import './controllers/token_controller.dart';
import './controllers/coupon_controller.dart';
import './controllers/register_controller.dart';
import './layouts/main_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './controllers/store_controller.dart';
import './controllers/events_controller.dart';
import './services/initialization_service.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  await InitializationService.initialize();
  runApp(const MainAppWidget());
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
    // Usar un microtask para evitar bloquear el hilo principal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      if (!mounted) return;

      // Usar una ruta sin animación y sin transición
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
          fullscreenDialog: true,
        ),
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
        // AuthController se carga inmediatamente pero sin notificar cambios
        ChangeNotifierProvider(create: (_) => AuthController(), lazy: false),
        // El resto con lazy loading y sin notificar cambios iniciales
        ...[
          ChangeNotifierProvider(create: (_) => TokenController(), lazy: true),
          ChangeNotifierProvider(create: (_) => StoreController(), lazy: true),
          ChangeNotifierProvider(create: (_) => CouponController(), lazy: true),
          ChangeNotifierProvider(
            create: (_) => RegisterController(),
            lazy: true,
          ),
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
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: child!,
          );
        },
        theme: ThemeData(
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const InitialLoadingScreen(),
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
