import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../layouts/main_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<ProfileController>();
    final authController = context.watch<AuthController>();
    
    // Determinar si es tienda o usuario
    final bool isStore = authController.isStore ?? false;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: AppTheme.headerDecoration,
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.primaryColor,
                      height: MediaQuery.of(context).padding.top,
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
          ),
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
                  // Avatar with initials o logo de tienda
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 8,
                      ),
                    ),
                    child: isStore 
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: authController.image != null 
                            ? NetworkImage(authController.image!) 
                            : null,
                        child: authController.image == null
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
                  ),
                  const SizedBox(height: 85),
                  // Options list según el tipo de usuario
                  Expanded(
                    child: isStore
                    ? ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 54),
                        children: [
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/Home.png',
                            title: 'Inicio',
                            onTap: () {
                              // Find the MainLayout state and navigate to Home (index 1)
                              final mainLayout = MainLayout.of(context);
                              if (mainLayout != null) {
                                mainLayout.navigateToTab(1);
                              }
                            },
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/Qr.png',
                            title: 'Crear cupones',
                            onTap: () {
                              // Implementar navegación a crear cupones
                            },
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/Camera.png',
                            title: 'Escanear cupones',
                            onTap: () {
                              // Implementar navegación a escanear cupones
                            },
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/services.png',
                            title: 'Configuraciones',
                            onTap: () {
                              // Implementar navegación a configuraciones
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
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 54),
                        children: [
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/reward.png',
                            title: 'Recompensas',
                            onTap: () {
                              // Find the MainLayout state and navigate
                              final mainLayout = MainLayout.of(context);
                              if (mainLayout != null) {
                                mainLayout.navigateToTab(0);
                              }
                            },
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/Home.png',
                            title: 'Inicio',
                            onTap: () {
                              // Find the MainLayout state and navigate to Home (index 1)
                              final mainLayout = MainLayout.of(context);
                              if (mainLayout != null) {
                                mainLayout.navigateToTab(1);
                              }
                            },
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/tickets.png',
                            title: 'Cupones',
                            onTap: () => Navigator.of(context).pushNamed('/coupons'),
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/store.png',
                            title: 'Tiendas participantes',
                            onTap: () => Navigator.of(context).pushNamed('/stores'),
                          ),
                          _buildOptionTile(
                            context,
                            iconPath: 'assets/icons/user/services.png',
                            title: 'Configuraciones',
                            onTap: () {
                              // TODO: Implement settings navigation
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