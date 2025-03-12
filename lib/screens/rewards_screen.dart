import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/token_controller.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Force data reload when screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    final tokenController = Provider.of<TokenController>(context, listen: false);
    
    // Reset and reload
    tokenController.reset();
    await tokenController.fetchUserTokens();
    
    setState(() {
      _isLoading = false;
    });
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
                    Padding(
                      padding: AppTheme.headerPadding,
                      child: Row(
                        children: [
                          Text(
                            'Recompensas',
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
              child: Consumer2<AuthController, TokenController>(
                builder: (context, auth, tokens, _) {
                  if (!auth.isAuthenticated) {
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

                  if (_isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

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
                                bottom: 100,
                              ),
                              child: Column(
                                children: tokens.rewardsHistory.map((reward) {
                                  final bool isSuccess = reward.status == 'success';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                                      decoration: BoxDecoration(
                                        color: isSuccess ? AppTheme.secondaryColor : AppTheme.greyColor,
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
                                            isSuccess ? 'assets/icons/like.png' : 'assets/icons/cancel.png',
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 