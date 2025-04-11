import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/coupon_controller.dart';
import '../models/coupon_model.dart';
import '../models/coupon_status.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

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
              child: Consumer<CouponController>(
                builder: (context, controller, child) {
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
    return ClipRRect(
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
                              color: Colors.black.withAlpha(179),
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
                                color: Colors.black.withAlpha(153),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Válido hasta: ${DateFormat('dd/MM/yyyy').format(coupon.expirationDate)}',
                                  style: AppTheme.bodyMedium.copyWith(
                                    fontSize: 12,
                                    color: Colors.black.withAlpha(153),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${coupon.tokensRequired} tokens',
                                style: AppTheme.bodyMedium.copyWith(
                                  fontSize: 12,
                                  color: Colors.black.withAlpha(153),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    // Show QR code only for available coupons
                    if (isAvailable)
                      QrImageView(
                        data: coupon.id,
                        version: QrVersions.auto,
                        size: 50.0,
                        backgroundColor: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Returns the appropriate icon based on coupon status
  Widget _getLeadingIcon(CouponModel coupon) {
    switch (coupon.status) {
      case CouponStatus.available:
        return Icon(
          CupertinoIcons.ticket_fill,
          size: 24,
          color: AppTheme.primaryColor,
        );
      case CouponStatus.locked:
        return Icon(
          CupertinoIcons.lock_fill,
          size: 24,
          color: AppTheme.greyColor,
        );
      case CouponStatus.used:
        return Icon(
          CupertinoIcons.checkmark_circle_fill,
          size: 24,
          color: AppTheme.greyColor,
        );
      case CouponStatus.expired:
        return Icon(
          CupertinoIcons.xmark_circle_fill,
          size: 24,
          color: AppTheme.greyColor,
        );
    }
  }
}
