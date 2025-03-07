import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/rewards_screen.dart';
import '../navigation/bottom_navigation.dart';

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
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const RewardsScreen(),
      const HomeScreen(),
      const LoginScreen(),
    ];
    if (widget.selectedIndex != null) {
      _currentIndex = widget.selectedIndex!;
    }
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      // Main content area
      body: SafeArea(
        bottom: false,
        child: widget.child ?? _screens[_currentIndex],
      ),
      // Custom navigation bar
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onItemTapped: _handleNavigation,
      ),
    );
  }
} 