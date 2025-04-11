import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/token_controller.dart';
import '../controllers/coupon_controller.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/coupon_model.dart';
import './create_coupon_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  static void refreshCoupons(BuildContext context) {
    debugPrint('Intentando refrescar cupones...');
    final couponController = Provider.of<CouponController>(
      context,
      listen: false,
    );
    couponController.fetchStoreCoupons();
  }

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    // Escuchar cambios en la autenticación
    AuthService.addAuthStateListener(_handleAuthChange);
    // Force data reload when screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserData();
    });
  }

  @override
  void dispose() {
    AuthService.removeAuthStateListener(_handleAuthChange);
    super.dispose();
  }

  void _handleAuthChange() {
    if (mounted) {
      loadUserData();
    }
  }

  Future<void> loadUserData() async {
    if (!mounted) return;

    debugPrint('Iniciando carga de datos del usuario...');
    final tokenController = Provider.of<TokenController>(
      context,
      listen: false,
    );
    final authController = Provider.of<AuthController>(context, listen: false);
    final couponController = Provider.of<CouponController>(
      context,
      listen: false,
    );

    // Reset and reload tokens
    tokenController.reset();
    await tokenController.fetchUserTokens();

    debugPrint('Verificando si el usuario es tienda...');
    debugPrint('isStore: ${authController.isStore}');
    debugPrint('isAuthenticated: ${authController.isAuthenticated}');
    debugPrint('userId: ${AuthService.userId}');

    if (authController.isStore == true) {
      debugPrint('El usuario es una tienda, cargando cupones...');
      await couponController.fetchStoreCoupons();
    } else {
      debugPrint('El usuario no es una tienda, reseteando cupones');
      couponController.reset();
    }
  }

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
                    Consumer<AuthController>(
                      builder:
                          (context, auth, _) => Padding(
                            padding: AppTheme.headerPadding,
                            child: Row(
                              children: [
                                Text(
                                  auth.isStore == true
                                      ? 'Mis Cupones'
                                      : 'Recompensas',
                                  style: AppTheme.titleMedium,
                                ),
                              ],
                            ),
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
              child:
                  Consumer3<AuthController, TokenController, CouponController>(
                    builder: (context, auth, tokens, coupons, _) {
                      if (!auth.isAuthenticated) {
                        return _buildUnauthenticatedView();
                      }

                      if (coupons.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Render store-specific view for store users
                      if (auth.isStore == true) {
                        if (coupons.coupons.isEmpty) {
                          return Center(
                            child: Text(
                              'No hay cupones creados',
                              style: AppTheme.titleSmall,
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: AppTheme.screenPadding.copyWith(top: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cupones Activos',
                                    style: AppTheme.titleSmall.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${coupons.coupons.length} cupones',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.screenPadding.left,
                                  vertical: 16,
                                ),
                                itemCount: coupons.coupons.length,
                                itemBuilder: (context, index) {
                                  final coupon = coupons.coupons[index];
                                  return _buildCouponCard(coupon);
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      // Render regular user view for non-store users
                      return _buildUserRewardsView(tokens);
                    },
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<AuthController>(
        builder: (context, auth, _) {
          if (auth.isStore == true) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCouponScreen(),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUnauthenticatedView() {
    return Column(
      children: [
        // Token balance display section
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$0',
                      style: AppTheme.tokenAmount.copyWith(
                        color: AppTheme.accentColor,
                        fontSize: 74,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cocoa Tokens',
                style: AppTheme.tokenLabel.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Login message
        Padding(
          padding: AppTheme.screenPadding.copyWith(top: 48),
          child: Text(
            'Inicia sesión para comenzar a ganar Cocoa Tokens',
            style: AppTheme.titleSmall.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildUserRewardsView(TokenController tokens) {
    return Column(
      children: [
        // Token balance display section
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${tokens.tokens}',
                      style: AppTheme.tokenAmount.copyWith(
                        color: AppTheme.accentColor,
                        fontSize: 74,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cocoa Tokens',
                style: AppTheme.tokenLabel.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Section title for performed actions
        Padding(
          padding: AppTheme.screenPadding.copyWith(top: 48, bottom: 2),
          child: Text(
            'Acciones realizadas',
            style: AppTheme.titleSmall.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        // Reward cards section with scroll
        Expanded(
          child: SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppTheme.screenPadding.left,
                  right: AppTheme.screenPadding.right,
                  top: 0,
                  bottom: 20,
                ),
                child: Column(
                  children:
                      tokens.rewardsHistory.map((reward) {
                        // Usamos la comparación directa con el enum
                        final bool isSuccess =
                            reward.status == RewardStatus.success;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 40,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSuccess
                                      ? AppTheme.secondaryColor
                                      : AppTheme.greyColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(26),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  isSuccess
                                      ? 'assets/icons/like.png'
                                      : 'assets/icons/cancel.png',
                                  width: 62,
                                  height: 62,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reward.title,
                                        style: AppTheme.bodyLarge.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        reward.subtitle,
                                        style: AppTheme.bodyMedium.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${reward.tokens} Cocoa Tokens',
                                        style: AppTheme.bodyLarge.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponCard(CouponModel coupon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateCouponScreen(existingCoupon: coupon),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      coupon.name,
                      style: AppTheme.titleSmall.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${coupon.tokensRequired} tokens',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                coupon.description,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estado: ${coupon.getStatusString()}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withAlpha(179),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Válido hasta: ${coupon.expirationDate.day}/${coupon.expirationDate.month}/${coupon.expirationDate.year}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withAlpha(179),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
