import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';
import '../navigation/bottom_navigation.dart';

class MainLayoutController {
  static final MainLayoutController _instance = MainLayoutController._internal();
  late PageController pageController;

  factory MainLayoutController() {
    return _instance;
  }

  MainLayoutController._internal() {
    pageController = PageController(initialPage: 1);
  }
}

class MainLayout extends StatefulWidget {
  final Widget? child;
  final int? selectedIndex;
  static MainLayoutController controller = MainLayoutController();

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
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const RewardsScreen(),
      const HomeScreen(),
      const ProfileScreen(),
    ];
    if (widget.selectedIndex != null) {
      _currentIndex = widget.selectedIndex!;
      MainLayout.controller.pageController.jumpToPage(_currentIndex);
    }
  }

  @override
  void dispose() {
    // No necesitamos dispose aquí ya que el controller es singleton
    super.dispose();
  }

  void _handleNavigation(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
    MainLayout.controller.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: widget.child ?? PageView(
          controller: MainLayout.controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
          onPageChanged: (index) {
            if (!mounted) return;
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onItemTapped: _handleNavigation,
      ),
    );
  }
} 