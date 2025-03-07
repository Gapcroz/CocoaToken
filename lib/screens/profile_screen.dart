import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Usuario',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 52),
          // Avatar con iniciales
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 8,
              ),
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[300],
              child: Text(
                'AP',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 85,
                ),
              ),
            ),
          ),
          const SizedBox(height: 85),
          // Lista de opciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 54),
              children: [
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/reward.png',
                  title: 'Recompensas',
                  onTap: profileController.navigateToRewards,
                ),
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/Home.png',
                  title: 'Inicio',
                  onTap: profileController.navigateToHome,
                ),
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/tickets.png',
                  title: 'Cupones',
                  onTap: profileController.navigateToCoupons,
                ),
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/store.png',
                  title: 'Tiendas participantes',
                  onTap: profileController.navigateToStores,
                ),
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/services.png',
                  title: 'Configuraciones',
                  onTap: () {
                    // TODO: Implementar navegación a configuraciones
                  },
                ),
                _buildOptionTile(
                  context,
                  iconPath: 'assets/icons/user/logout.png',
                  title: 'Cerrar sesión',
                  onTap: () {
                    final authController = context.read<AuthController>();
                    authController.logout();
                    profileController.logout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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