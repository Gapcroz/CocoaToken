import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';
import '../screens/login_screen.dart';
import '../navigation/bottom_navigation.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

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

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 1;
  late final List<Widget> _baseScreens;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initializeBaseScreens();
    _currentIndex = widget.selectedIndex ?? 1;
    _pageController = PageController(initialPage: _currentIndex);
    
    // Check authentication status on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().checkAuthStatus();
    });
  }

  void _initializeBaseScreens() {
    _baseScreens = [
      const RewardsScreen(),
      const HomeScreen(),
    ];
  }

  List<Widget> _getScreens(bool isAuthenticated) {
    return [
      ..._baseScreens,
      isAuthenticated ? const ProfileScreen() : const LoginScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 1) {
          _handleNavigation(1);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Material(
          type: MaterialType.transparency,
          child: Consumer<AuthController>(
            builder: (context, auth, _) {
              final screens = _getScreens(auth.isAuthenticated);
              final isLoginScreen = !auth.isAuthenticated && _currentIndex == 2;
              return Container(
                decoration: BoxDecoration(
                  color: isLoginScreen ? AppTheme.primaryColor : AppTheme.primaryColor,
                ),
                child: SafeArea(
                  bottom: !isLoginScreen,
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigation(
            currentIndex: _currentIndex,
            onItemTapped: _handleNavigation,
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
} 