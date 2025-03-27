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

class MainLayoutState extends State<MainLayout> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  static MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainLayoutState>();
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (auth.justLoggedOut && _currentIndex == 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentIndex = 1;
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
              );
            });
            auth.resetLogoutFlag();
          });
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const RewardsScreen(),
              const HomeScreen(),
              auth.isAuthenticated
                  ? const ProfileScreen()
                  : const LoginScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onItemTapped: setIndex,
          ),
        );
      },
    );
  }
}

// Añade esta clase para manejar la navegación
class MainLayoutNavigator {
  static void navigateToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<MainLayoutState>();
    state?.setIndex(index);
  }
}
