import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './stores_screen.dart';
import './coupons_screen.dart';
import './events_screen.dart';
import '../theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/token_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  // Points container - only visible when authenticated AND user is not a store
                  Consumer2<AuthController, TokenController>(
                    builder: (context, auth, tokens, _) {
                      if (_isLoading) {
                        return Padding(
                          padding: AppTheme.screenPadding.copyWith(top: 16.0),
                          child: const SizedBox(
                            height: 38,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      
                      return Padding(
                        padding: AppTheme.screenPadding.copyWith(top: 16.0),
                        child: SizedBox(
                          height: 38, // fixed height for consistency
                          child: auth.isAuthenticated && !(auth.isStore ?? false)
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '\$${tokens.tokens} CP',
                                    style: AppTheme.tokenAmount.copyWith(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EventsScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 35),
                          _buildMainButton(
                            context,
                            imagePath: 'assets/icons/store.png',
                            label: 'Tiendas participantes',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const StoresScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
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