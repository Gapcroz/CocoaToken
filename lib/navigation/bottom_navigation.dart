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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icons/rewards.png', 'Recompensas'),
          _buildNavItem(1, 'assets/icons/home.png', 'Inicio'),
          _buildNavItem(2, 'assets/icons/add_user.png', 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final bool isSelected = widget.currentIndex == index;
    final double iconSize = isSelected ? 32 : 28;
    final double topPadding = isSelected ? 14 : 18;

    return InkWell(
      onTap: () => widget.onItemTapped(index),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 95,
        child: Column(
          children: [
            SizedBox(height: topPadding),
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              color: isSelected ? Colors.white : Colors.white.withAlpha(153),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withAlpha(153),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
