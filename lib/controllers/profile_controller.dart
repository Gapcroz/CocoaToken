import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';

class ProfileController extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToRewards() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
    MainLayout.controller.pageController.jumpToPage(0); // Índice de Recompensas
  }

  void navigateToHome() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
    MainLayout.controller.pageController.jumpToPage(1); // Índice de Home
  }

  void navigateToCoupons() {
    navigatorKey.currentState?.pushNamed('/coupons');
  }

  void navigateToStores() {
    navigatorKey.currentState?.pushNamed('/stores');
  }

  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
} 