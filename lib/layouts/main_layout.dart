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
  static final List<Widget> _screens = [
    const KeepAliveWrapper(child: RewardsScreen()),
    const KeepAliveWrapper(child: HomeScreen()),
    const ProfileScreenWrapper(),
  ];

  late final PageController _pageController;
  int _currentIndex = 1;
  bool _isAnimating = false;

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
    if (_currentIndex == index || _isAnimating) return;

    _isAnimating = true;
    setState(() => _currentIndex = index);

    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<AuthController, bool>(
      selector: (_, auth) => auth.justLoggedOut,
      builder: (context, justLoggedOut, child) {
        if (justLoggedOut && _currentIndex == 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setIndex(1);
            context.read<AuthController>().resetLogoutFlag();
          });
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onItemTapped: setIndex,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  static MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainLayoutState>();
  }
}

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
      child: Consumer<AuthController>(
        builder:
            (context, auth, _) =>
                auth.isAuthenticated
                    ? const ProfileScreen()
                    : const LoginScreen(),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class MainLayoutNavigator {
  static void navigateToTab(BuildContext context, int index) {
    final state = MainLayoutState.of(context);
    state?.setIndex(index);
  }
}
