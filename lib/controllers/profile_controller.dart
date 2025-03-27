import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../layouts/main_layout.dart';

class ProfileController extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  void updateBottomNavIndex(BuildContext context, int index) {
    final state = MainLayoutState.of(context);
    state?.setIndex(index);
  }

  void logout(BuildContext context) {
    final authController = context.read<AuthController>();
    authController.logout();
  }
}
