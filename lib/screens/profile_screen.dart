import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../screens/coupons_screen.dart';
import '../screens/stores_screen.dart';
import './create_coupon_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleNavigation(BuildContext context, String route) {
    final profileController = context.read<ProfileController>();

    switch (route) {
      case '/home':
        profileController.updateBottomNavIndex(context, 1);
        break;
      case '/rewards':
        profileController.updateBottomNavIndex(context, 0);
        break;
      case '/coupons':
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const CouponsScreen(),
                fullscreenDialog: true,
              ),
            )
            .then((_) {
              if (context.mounted) {
                profileController.updateBottomNavIndex(
                  context,
                  1,
                ); // Volver a Home
              }
            });
        break;
      case '/stores':
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const StoresScreen(),
                fullscreenDialog: true,
              ),
            )
            .then((_) {
              if (context.mounted) {
                profileController.updateBottomNavIndex(
                  context,
                  1,
                ); // Volver a Home
              }
            });
        break;
      case '/settings':
        ProfileController.navigatorKey.currentState?.pushNamed('/settings');
        break;
      case '/create-coupons':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CreateCouponScreen(),
            fullscreenDialog: true,
          ),
        );
        break;
      case '/scan-coupons':
        ProfileController.navigatorKey.currentState?.pushNamed('/scan-coupons');
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    final profileController = context.read<ProfileController>();
    profileController.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final bool isStore = authController.isStore ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(isStore),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 52),
                  _buildAvatar(authController, isStore),
                  const SizedBox(height: 85),
                  Expanded(
                    child:
                        isStore
                            ? _buildStoreOptions(context)
                            : _buildUserOptions(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isStore) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.headerDecoration,
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  return Container(
                    color: AppTheme.primaryColor,
                    height: MediaQuery.of(context).padding.top,
                  );
                },
              ),
              Padding(
                padding: AppTheme.headerPadding,
                child: Row(
                  children: [
                    Text(
                      isStore ? 'Tienda' : 'Usuario',
                      style: AppTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(AuthController authController, bool isStore) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryColor, width: 8),
      ),
      child:
          isStore
              ? CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    authController.image != null
                        ? NetworkImage(authController.image!)
                        : null,
                child:
                    authController.image == null
                        ? Icon(
                          Icons.store_rounded,
                          size: 85,
                          color: AppTheme.accentColor,
                        )
                        : null,
              )
              : CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                child: Text(
                  AuthService.currentUser?.initials ?? '??',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 85,
                  ),
                ),
              ),
    );
  }

  Widget _buildStoreOptions(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 54),
      children: [
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/Home.png',
          title: 'Inicio',
          onTap: () => _handleNavigation(context, '/home'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/Qr.png',
          title: 'Crear cupones',
          onTap: () => _handleNavigation(context, '/create-coupons'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/Camera.png',
          title: 'Escanear cupones',
          onTap: () => _handleNavigation(context, '/scan-coupons'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/services.png',
          title: 'Configuraciones',
          onTap: () => _handleNavigation(context, '/settings'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/logout.png',
          title: 'Cerrar sesión',
          onTap: () => _handleLogout(context),
        ),
      ],
    );
  }

  Widget _buildUserOptions(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 54),
      children: [
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/reward.png',
          title: 'Recompensas',
          onTap: () => _handleNavigation(context, '/rewards'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/Home.png',
          title: 'Inicio',
          onTap: () => _handleNavigation(context, '/home'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/tickets.png',
          title: 'Cupones',
          onTap: () => _handleNavigation(context, '/coupons'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/store.png',
          title: 'Tiendas participantes',
          onTap: () => _handleNavigation(context, '/stores'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/services.png',
          title: 'Configuraciones',
          onTap: () => _handleNavigation(context, '/settings'),
        ),
        _buildOptionTile(
          context,
          iconPath: 'assets/icons/user/logout.png',
          title: 'Cerrar sesión',
          onTap: () => _handleLogout(context),
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 35,
        height: 35,
        color: AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: AppTheme.bodyLarge.copyWith(
          color: AppTheme.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      dense: true,
    );
  }
}
