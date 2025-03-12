import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';
import '../screens/login_screen.dart';
import '../navigation/bottom_navigation.dart';
import '../controllers/auth_controller.dart';
import '../controllers/token_controller.dart';
import '../controllers/coupon_controller.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  final Widget? child;
  final int? selectedIndex;

  const MainLayout({
    super.key,
    this.child,
    this.selectedIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  int _currentIndex = 1;
  late final List<Widget> _baseScreens;
  late final PageController _pageController;
  bool _isInitialized = false;
  bool _isDataLoading = false;
  bool _areFontsLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBaseScreens();
    _currentIndex = widget.selectedIndex ?? 1;
    _pageController = PageController(initialPage: _currentIndex);
    
    // Diferir la inicialización
    _scheduleInitialization();
  }
  
  void _scheduleInitialization() {
    // Programar la inicialización para después de que se dibuje el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        _checkAuthStatus();
        _loadFonts();
        _precacheImages();
      }
    });
  }
  
  Future<void> _loadFonts() async {
    // No cargar fuentes inmediatamente, esperar a que la UI esté estable
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    try {
      // Cargar fuentes en segundo plano
      await GoogleFonts.pendingFonts([
        GoogleFonts.poppins(),
      ]);
      
      if (mounted) {
        setState(() {
          _areFontsLoaded = true;
        });
      }
    } catch (e) {
      // Ignorar errores de carga de fuentes
    }
  }
  
  Future<void> _precacheImages() async {
    try {
      // Usar la ruta original de las imágenes
      await precacheImage(const AssetImage('assets/cocoalogo.png'), context);
      
      // Otras imágenes si las hay
      // await precacheImage(const AssetImage('assets/otra_imagen.png'), context);
    } catch (e) {
      // Ignorar errores de precarga
    }
  }
  
  Future<void> _checkAuthStatus() async {
    if (_isInitialized) return;
    
    final authController = context.read<AuthController>();
    await authController.checkAuthStatus();
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
    
    // Programar la carga de datos para más tarde
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadDataInBackground();
      }
    });
  }
  
  Future<void> _loadDataInBackground() async {
    if (_isDataLoading) return;
    _isDataLoading = true;
    
    // Esperar más tiempo antes de cargar datos
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    final authController = context.read<AuthController>();
    
    if (authController.isAuthenticated) {
      try {
        // Cargar tokens
        final tokenController = context.read<TokenController>();
        await Future.microtask(() {
          tokenController.fetchUserTokens();
        });
        
        // Esperar más tiempo antes de cargar cupones
        await Future.delayed(const Duration(milliseconds: 1000));
        
        if (!mounted) return;
        
        // Cargar cupones
        final couponController = context.read<CouponController>();
        await Future.microtask(() {
          couponController.fetchUserCoupons();
        });
      } catch (e) {
        // Ignorar errores durante la carga
      }
    }
    
    _isDataLoading = false;
  }

  void _initializeBaseScreens() {
    _baseScreens = [
      const RewardsScreen(),
      const HomeScreen(),
    ];
  }

  List<Widget> _getScreens(bool isAuthenticated) {
    return [
      const RewardsScreen(),
      const HomeScreen(),
      isAuthenticated ? const ProfileScreen() : const LoginScreen(),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Recargar datos cuando la app vuelve al primer plano
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _loadDataInBackground();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Handle navigation from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int && args >= 0 && args <= 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _handleNavigation(args);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aplicar tema con o sin fuentes personalizadas
    final theme = _areFontsLoaded 
        ? Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          )
        : Theme.of(context);
        
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 1) {
            _handleNavigation(1);
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF111827),
          extendBody: true,
          body: Material(
            type: MaterialType.transparency,
            child: Consumer<AuthController>(
              builder: (context, auth, _) {
                final screens = _getScreens(auth.isAuthenticated);
                final isLoginScreen = !auth.isAuthenticated && _currentIndex == 2;
                return Container(
                  decoration: BoxDecoration(
                    color: isLoginScreen ? const Color(0xFF111827) : const Color(0xFF111827),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: screens,
                      onPageChanged: (index) {
                        if (!mounted) return;
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onItemTapped: _handleNavigation,
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (!mounted) return;
    
    // Asegurarse de que el índice sea válido
    if (index < 0 || index > 2) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    // Animar a la página correcta
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
} 