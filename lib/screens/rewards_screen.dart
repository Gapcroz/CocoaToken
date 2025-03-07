import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with rewards title
        Container(
          width: double.infinity,
          decoration: AppTheme.headerDecoration,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: AppTheme.headerPadding,
              child: Text(
                'Recompensas',
                style: AppTheme.titleMedium,
              ),
            ),
          ),
        ),
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
                      '\$5',
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
          padding: AppTheme.screenPadding.copyWith(top: 48, bottom: 24),
          child: Text(
            'Acciones realizadas',
            style: AppTheme.titleSmall.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        // Reward cards section
        Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            children: [
              // Active reward card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/like.png',
                      width: 62,
                      height: 62,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Votación exitosa',
                            style: AppTheme.bodyLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Recompensa',
                            style: AppTheme.bodyMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '5 Cocoa Tokens',
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
              const SizedBox(height: 16),
              // Expired reward card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                decoration: BoxDecoration(
                  color: AppTheme.greyColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/cancel.png',
                      width: 62,
                      height: 62,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recompensa vencida',
                            style: AppTheme.bodyLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Recompensa',
                            style: AppTheme.bodyMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '0 Cocoa Tokens',
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
            ],
          ),
        ),
      ],
    );
  }
} 