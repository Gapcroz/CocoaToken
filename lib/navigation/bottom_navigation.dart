import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // Constants to avoid recreations
  static const double _navHeight = 120.0;
  static const Color _backgroundColor = Color(0xFF111827);
  static const Color _borderColor = Color(0xFF1E293B);

  static const List<NavItem> _items = [
    NavItem(icon: 'assets/icons/rewards.png', label: 'Recompensas', index: 0),
    NavItem(icon: 'assets/icons/home.png', label: 'Inicio', index: 1),
  ];

  void _handleTap(int index) {
    if (widget.currentIndex != index) {
      widget.onItemTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _navHeight,
      decoration: const BoxDecoration(
        color: _backgroundColor,
        border: Border(top: BorderSide(color: _borderColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ..._items.map(
            (item) => _NavItemWidget(
              item: item,
              isSelected: widget.currentIndex == item.index,
              onTap: _handleTap,
            ),
          ),
          _buildProfileItem(),
        ],
      ),
    );
  }

  Widget _buildProfileItem() {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        final bool isSelected = widget.currentIndex == 2;
        final itemWidth = MediaQuery.of(context).size.width / 3;

        return GestureDetector(
          onTap: () => _handleTap(2),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: itemWidth,
            height: 120,
            child: Column(
              children: [
                SizedBox(height: isSelected ? 8.0 : 12.0),
                _buildProfileContent(auth, isSelected),
                const SizedBox(height: 4),
                Text(
                  'Perfil',
                  style: TextStyle(
                    color: Colors.white.withAlpha(isSelected ? 255 : 153),
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(AuthController auth, bool isSelected) {
    final size = isSelected ? 32.0 : 28.0;

    if (!auth.isAuthenticated) {
      return Image.asset(
        'assets/icons/add_user.png',
        width: size,
        height: size,
        color: Colors.white.withAlpha(isSelected ? 255 : 153),
      );
    }

    if (auth.image != null && auth.image!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          auth.image!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  _buildInitials(auth.name ?? '', size),
        ),
      );
    }

    return _buildInitials(auth.name ?? '', size);
  }

  Widget _buildInitials(String name, double size) {
    final initials =
        name.isNotEmpty
            ? name
                .split(' ')
                .take(2)
                .map((e) => e.isNotEmpty ? e[0] : '')
                .join('')
            : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(153),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Immutable model for navigation items
@immutable
class NavItem {
  final String icon;
  final String label;
  final int index;

  const NavItem({required this.icon, required this.label, required this.index});
}

// Separated widget for each navigation item
class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final Function(int) onTap;

  // Design constants
  static const double _selectedIconSize = 32.0;
  static const double _unselectedIconSize = 28.0;
  static const double _selectedTopPadding = 8.0;
  static const double _unselectedTopPadding = 12.0;
  static const double _labelSize = 12.0;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = MediaQuery.of(context).size.width / 3;

        return GestureDetector(
          onTap: () => onTap(item.index),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: itemWidth,
            height: 120,
            child: Column(
              children: [
                SizedBox(
                  height:
                      isSelected ? _selectedTopPadding : _unselectedTopPadding,
                ),
                _buildIcon(),
                const SizedBox(height: 4),
                _buildLabel(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      item.icon,
      width: isSelected ? _selectedIconSize : _unselectedIconSize,
      height: isSelected ? _selectedIconSize : _unselectedIconSize,
      color: Colors.white.withAlpha(isSelected ? 255 : 153),
    );
  }

  Widget _buildLabel() {
    return Text(
      item.label,
      style: TextStyle(
        color: Colors.white.withAlpha(isSelected ? 255 : 153),
        fontSize: _labelSize,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
