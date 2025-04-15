import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../controllers/coupon_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/coupon_model.dart';
import '../models/coupon_status.dart';
import '../theme/app_theme.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = CouponController();
        // Initialize coupons loading
        controller.fetchUserCoupons();
        return controller;
      },
      child: Scaffold(
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
                        padding: AppTheme.headerPadding.copyWith(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                'assets/icons/arrow.png',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text('Cupones', style: AppTheme.titleMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer2<AuthController, CouponController>(
                builder: (context, auth, controller, child) {
                  if (!auth.isAuthenticated) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.ticket_fill,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Inicia sesión para ver tus cupones',
                            style: AppTheme.titleMedium.copyWith(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.error != null) {
                    return Center(child: Text(controller.error!));
                  }

                  // Combine available and locked coupons for display
                  final allCoupons = [
                    ...controller.availableCoupons,
                    ...controller.lockedCoupons,
                  ];

                  if (allCoupons.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.ticket_fill,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes cupones disponibles',
                            style: AppTheme.titleMedium.copyWith(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    itemCount: allCoupons.length,
                    itemBuilder: (context, index) {
                      final coupon = allCoupons[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCouponCard(
                          context,
                          coupon: coupon,
                          isAvailable: coupon.status == CouponStatus.available,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the coupon card with its information and QR code
  Widget _buildCouponCard(
    BuildContext context, {
    required CouponModel coupon,
    required bool isAvailable,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: AppTheme.secondaryColor,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono grande a la izquierda, centrado verticalmente
              Container(
                margin: const EdgeInsets.only(right: 24),
                child: _getLeadingIcon(coupon),
              ),
              // Contenido a la derecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título
                    Text(
                      coupon.name,
                      style: AppTheme.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Descripción
                    Text(
                      coupon.description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withAlpha(204),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Chip de tokens
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(77),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${coupon.tokensRequired} tokens',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Fecha de validez
                    Text(
                      'Válido hasta: ${coupon.expirationDate.day}/${coupon.expirationDate.month}/${coupon.expirationDate.year}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withAlpha(179),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icono de regalo por defecto
  Widget _getLeadingIcon(CouponModel coupon) {
    return Icon(Icons.card_giftcard, size: 72, color: Colors.white);
  }
}
