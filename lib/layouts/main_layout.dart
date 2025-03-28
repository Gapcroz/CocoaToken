import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../screens/rewards_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../navigation/bottom_navigation.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout>
    with AutomaticKeepAliveClientMixin {
  late final PageController _pageController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, keepPage: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setIndex(int index) {
    if (_currentIndex == index) return; // Evitar animaciones innecesarias

    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (auth.justLoggedOut && _currentIndex == 2) {
          // Usar microtask para evitar setState durante el build
          Future.microtask(() {
            setIndex(1);
            auth.resetLogoutFlag();
          });
        }

        return Scaffold(
          body: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // Lazy loading de las páginas
              return _buildPage(index, auth);
            },
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onItemTapped: setIndex,
          ),
        );
      },
    );
  }

  Widget _buildPage(int index, AuthController auth) {
    switch (index) {
      case 0:
        return const KeepAliveWrapper(child: RewardsScreen());
      case 1:
        return const KeepAliveWrapper(child: HomeScreen());
      case 2:
        return KeepAliveWrapper(
          child:
              auth.isAuthenticated
                  ? const ProfileScreen()
                  : const LoginScreen(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  bool get wantKeepAlive => true;

  static MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainLayoutState>();
  }
}

// Añade esta clase para manejar la navegación
class MainLayoutNavigator {
  static void navigateToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<MainLayoutState>();
    state?.setIndex(index);
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => KeepAliveWrapperState();
}

class KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
