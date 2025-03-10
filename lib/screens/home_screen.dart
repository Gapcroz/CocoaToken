import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './stores_screen.dart';
import './coupons_screen.dart';
import '../theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/token_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            'Inicio',
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
                  // Points container - only visible when authenticated
                  Consumer2<AuthController, TokenController>(
                    builder: (context, auth, tokens, _) {
                      if (!auth.isAuthenticated) return const SizedBox.shrink();
                      
                      return Padding(
                        padding: AppTheme.screenPadding.copyWith(top: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$${tokens.tokens} CP',
                            style: AppTheme.tokenAmount.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Main content centered
                  Expanded(
                    child: Padding(
                      padding: AppTheme.screenPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 35),
                          _buildMainButton(
                            context,
                            imagePath: 'assets/icons/events.png',
                            label: 'Eventos sociales',
                            onTap: () {
                              // TODO: Implement social events
                            },
                          ),
                          const SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActionButton(
                                context,
                                imagePath: 'assets/icons/like.png',
                                label: 'Votaciones',
                                onTap: () {
                                  // TODO: Implement voting
                                },
                              ),
                              _buildActionButton(
                                context,
                                imagePath: 'assets/icons/store.png',
                                label: 'Participating stores',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const StoresScreen(),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                          _buildCouponButton(
                            context,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CouponsScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

  Widget _buildMainButton(
    BuildContext context, {
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: color ?? AppTheme.accentColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 3,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTheme.bodyLarge.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - (24.0 * 2) - 24.0) / 2;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: 160,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 3,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTheme.bodyLarge.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponButton(BuildContext context, {required VoidCallback onTap}) {
    return _buildMainButton(
      context,
      imagePath: 'assets/icons/two_tickets.png',
      label: 'Cupones',
      onTap: onTap,
      color: AppTheme.secondaryColor,
    );
  }
} 