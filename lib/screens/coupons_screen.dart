import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../controllers/coupon_controller.dart';
import '../models/coupon_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import './coupon_detail_screen.dart';
import 'package:intl/intl.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = CouponController();
        // Load coupons immediately
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
              child: Consumer<CouponController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.error != null) {
                    return Center(child: Text(controller.error!));
                  }

                  final allCoupons = [
                    ...controller.availableCoupons,
                    ...controller.lockedCoupons,
                  ];

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

  Widget _buildCouponCard(
    BuildContext context, {
    required CouponModel coupon,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap:
          isAvailable
              ? () => _navigateToCouponDetail(context, coupon)
              : null, // If not available, do nothing on click
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 95,
          decoration: BoxDecoration(
            color: isAvailable ? AppTheme.secondaryColor : AppTheme.greyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _getLeadingIcon(coupon),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.name,
                              style: AppTheme.bodyLarge.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon.description,
                              style: AppTheme.bodyMedium.copyWith(
                                fontSize: 14,
                                color: Colors.black.withAlpha(
                                  179,
                                ), // 0.7 opacity
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  isAvailable
                                      ? CupertinoIcons.time
                                      : CupertinoIcons.calendar,
                                  size: 14,
                                  color: Colors.black.withAlpha(
                                    153,
                                  ), // 0.6 opacity
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Válido hasta: ${DateFormat('dd/MM/yyyy').format(coupon.expirationDate)}',
                                    style: AppTheme.bodyMedium.copyWith(
                                      fontSize: 12,
                                      color: Colors.black.withAlpha(
                                        153,
                                      ), // 0.6 opacity
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAvailable)
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(26), // 0.1 opacity
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLeadingIcon(CouponModel coupon) {
    final nameLower = coupon.name.toLowerCase();
    final descLower = coupon.description.toLowerCase();
    String searchText = '$nameLower $descLower';
    IconData iconData;

    if (searchText.contains('café') || searchText.contains('bebida')) {
      iconData = CupertinoIcons.circle_grid_hex_fill;
    } else if (searchText.contains('comida') ||
        searchText.contains('restaurante') ||
        searchText.contains('ensalada')) {
      iconData = CupertinoIcons.circle_grid_3x3_fill;
    } else if (searchText.contains('cine') ||
        searchText.contains('película') ||
        searchText.contains('boleto')) {
      iconData = CupertinoIcons.rectangle_fill_on_rectangle_fill;
    } else if (searchText.contains('farmacia') ||
        searchText.contains('medicina') ||
        searchText.contains('aspirina')) {
      iconData = CupertinoIcons.plus_circle_fill;
    } else if (searchText.contains('descuento') || searchText.contains('%')) {
      iconData = CupertinoIcons.circle_grid_3x3;
    } else if (searchText.contains('regalo') ||
        searchText.contains('sorpresa')) {
      iconData = CupertinoIcons.gift_fill;
    } else if (searchText.contains('juego') ||
        searchText.contains('diversión')) {
      iconData = CupertinoIcons.gamecontroller_fill;
    } else if (searchText.contains('libro') || searchText.contains('lectura')) {
      iconData = CupertinoIcons.book_fill;
    } else if (searchText.contains('música') ||
        searchText.contains('concierto')) {
      iconData = CupertinoIcons.music_note_2;
    } else if (searchText.contains('viaje') || searchText.contains('vuelo')) {
      iconData = CupertinoIcons.airplane;
    } else {
      iconData = CupertinoIcons.tag_circle_fill;
    }

    return Icon(iconData, size: 44, color: Colors.black);
  }

  // Method to navigate to coupon detail screen
  void _navigateToCouponDetail(BuildContext context, CouponModel coupon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CouponDetailScreen(
              title: coupon.name,
              description: coupon.description, // Usar la descripción completa
              qrData:
                  'COUPON-${coupon.id}-${DateTime.now().millisecondsSinceEpoch}',
            ),
      ),
    );
  }
}
