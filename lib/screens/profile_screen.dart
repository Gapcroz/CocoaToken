import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../screens/coupons_screen.dart';
import '../screens/stores_screen.dart';
import './create_coupon_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Memoize options to avoid recreations
  static final List<_ProfileOption> _storeOptions = [
    _ProfileOption(
      iconPath: 'assets/icons/user/Home.png',
      title: 'Inicio',
      route: '/home',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/Qr.png',
      title: 'Crear cupones',
      route: '/create-coupons',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/Camera.png',
      title: 'Escanear cupones',
      route: '/scan-coupons',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/services.png',
      title: 'Configuraciones',
      route: '/settings',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/logout.png',
      title: 'Cerrar sesión',
      route: '/logout',
    ),
  ];

  static final List<_ProfileOption> _userOptions = [
    _ProfileOption(
      iconPath: 'assets/icons/user/reward.png',
      title: 'Recompensas',
      route: '/rewards',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/Home.png',
      title: 'Inicio',
      route: '/home',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/tickets.png',
      title: 'Cupones',
      route: '/coupons',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/store.png',
      title: 'Tiendas participantes',
      route: '/stores',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/services.png',
      title: 'Configuraciones',
      route: '/settings',
    ),
    _ProfileOption(
      iconPath: 'assets/icons/user/logout.png',
      title: 'Cerrar sesión',
      route: '/logout',
    ),
  ];

  // Memoized style constants
  static const _avatarRadius = 80.0;
  static const _optionsPadding = EdgeInsets.symmetric(horizontal: 54);

  void _handleNavigation(BuildContext context, String route) {
    if (route == '/logout') {
      _handleLogout(context);
      return;
    }

    final profileController = context.read<ProfileController>();

    switch (route) {
      case '/home':
        profileController.updateBottomNavIndex(context, 1);
        break;
      case '/rewards':
        profileController.updateBottomNavIndex(context, 0);
        break;
      case '/coupons':
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const CouponsScreen(),
                fullscreenDialog: true,
              ),
            )
            .then((_) {
              if (context.mounted) {
                profileController.updateBottomNavIndex(context, 1);
              }
            });
        break;
      case '/stores':
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const StoresScreen(),
                fullscreenDialog: true,
              ),
            )
            .then((_) {
              if (context.mounted) {
                profileController.updateBottomNavIndex(
                  context,
                  1,
                ); // Return to Home
              }
            });
        break;
      case '/settings':
        ProfileController.navigatorKey.currentState?.pushNamed('/settings');
        break;
      case '/create-coupons':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CreateCouponScreen(),
            fullscreenDialog: true,
          ),
        );
        break;
      case '/scan-coupons':
        ProfileController.navigatorKey.currentState?.pushNamed('/scan-coupons');
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    context.read<ProfileController>().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Selector<AuthController, bool>(
        selector: (_, auth) => auth.isStore ?? false,
        builder: (context, isStore, _) {
          return Column(
            children: [
              _ProfileHeader(isStore: isStore),
              Expanded(child: _ProfileBody(isStore: isStore)),
            ],
          );
        },
      ),
    );
  }
}

// Separated and optimized components
class _ProfileHeader extends StatelessWidget {
  final bool isStore;

  const _ProfileHeader({required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.headerDecoration,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
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
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final bool isStore;

  const _ProfileBody({required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _ProfileAvatar(isStore: isStore),
              const SizedBox(height: 45),
              Expanded(
                child: SingleChildScrollView(
                  child: _ProfileOptions(isStore: isStore),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final bool isStore;

  const _ProfileAvatar({required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryColor, width: 8),
      ),
      child: isStore ? _StoreAvatar() : _UserAvatar(),
    );
  }
}

class _StoreAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthController, String?>(
      selector: (_, auth) => auth.image,
      builder: (context, image, _) {
        return CircleAvatar(
          radius: ProfileScreen._avatarRadius,
          backgroundColor: Colors.grey[300],
          backgroundImage: image != null ? NetworkImage(image) : null,
          child:
              image == null
                  ? Icon(
                    Icons.store_rounded,
                    size: 85,
                    color: AppTheme.accentColor,
                  )
                  : null,
        );
      },
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: ProfileScreen._avatarRadius,
      backgroundColor: Colors.grey[300],
      child: Text(
        AuthService.currentUser?.initials ?? '??',
        style: AppTheme.titleLarge.copyWith(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 85,
        ),
      ),
    );
  }
}

class _ProfileOptions extends StatelessWidget {
  final bool isStore;

  const _ProfileOptions({required this.isStore});

  @override
  Widget build(BuildContext context) {
    final options =
        isStore ? ProfileScreen._storeOptions : ProfileScreen._userOptions;

    return Padding(
      padding: ProfileScreen._optionsPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options.map((option) => _OptionTile(option: option)).toList(),
      ),
    );
  }
}

class _OptionTile extends StatefulWidget {
  final _ProfileOption option;
  const _OptionTile({required this.option});

  @override
  State<_OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<_OptionTile> {
  late final Image _icon;

  @override
  void initState() {
    super.initState();
    _icon = Image.asset(
      widget.option.iconPath,
      width: 35,
      height: 35,
      color: AppTheme.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: _icon,
        title: Text(
          widget.option.title,
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap:
            () => context
                .findAncestorWidgetOfExactType<ProfileScreen>()
                ?._handleNavigation(context, widget.option.route),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        dense: true,
      ),
    );
  }
}

@immutable
class _ProfileOption {
  final String iconPath;
  final String title;
  final String route;

  const _ProfileOption({
    required this.iconPath,
    required this.title,
    required this.route,
  });
}
