import 'package:flutter/material.dart';

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
  static const double _navHeight = 95.0;
  static const Color _backgroundColor = Color(0xFF111827);
  static const Color _borderColor = Color(0xFF1E293B);

  static const List<NavItem> _items = [
    NavItem(icon: 'assets/icons/rewards.png', label: 'Recompensas', index: 0),
    NavItem(icon: 'assets/icons/home.png', label: 'Inicio', index: 1),
    NavItem(icon: 'assets/icons/add_user.png', label: 'Perfil', index: 2),
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
        children:
            _items
                .map(
                  (item) => _NavItemWidget(
                    item: item,
                    isSelected: widget.currentIndex == item.index,
                    onTap: _handleTap,
                  ),
                )
                .toList(),
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
  static const double _selectedTopPadding = 14.0;
  static const double _unselectedTopPadding = 18.0;
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
            height: 95,
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
