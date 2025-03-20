import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class ProfileController extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToRewards() {
    // Navigate to rewards screen by updating the index (0 is rewards tab)
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 0,
    );
  }

  void navigateToHome() {
    // Navigate to home screen by updating the index (1 is home tab)
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 1,
    );
  }

  void navigateToCoupons() {
    // This will continue to open as a new screen
    navigatorKey.currentState?.pushNamed('/coupons');
  }

  void navigateToStores() {
    // This will continue to open as a new screen
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

  void navigateToRewards2(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 0,
    );
  }

  void navigateToHome2(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
      arguments: 1,
    );
  }

  void navigateToCoupons2(BuildContext context) {
    Navigator.of(context).pushNamed('/coupons');
  }

  void navigateToStores2(BuildContext context) {
    Navigator.of(context).pushNamed('/stores');
  }
} 