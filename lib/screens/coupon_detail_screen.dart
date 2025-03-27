import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';

class CouponDetailScreen extends StatelessWidget {
  final String title;
  final String? description;
  final String? discount;
  final String qrData;

  const CouponDetailScreen({
    super.key,
    required this.title,
    this.description,
    this.discount,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    // Use description if available, otherwise use discount
    final String subtitleText = description ?? discount ?? 'Discount coupon';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with left-aligned title and rounded borders
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
                          Text(title, style: AppTheme.titleMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Content centered on screen
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Subtitle - using description/discount
                      Text(
                        subtitleText,
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Updated QR Code configuration
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 220.0,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppTheme.primaryColor,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Message to scan
                      Text(
                        'Scan me to claim your reward',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
