import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class ProfileController extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToRewards() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 0,
    );
  }

  void navigateToHome() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 1,
    );
  }

  void navigateToCoupons() {
    navigatorKey.currentState?.pushNamed('/coupons');
  }

  void navigateToStores() {
    navigatorKey.currentState?.pushNamed('/stores');
  }

  void logout(BuildContext context) {
    // First, log out from AuthController
    context.read<AuthController>().logout();
    // Return to home page
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 1,
    );
  }
} 