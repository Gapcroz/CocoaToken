import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

class _BottomNavigationState extends State<BottomNavigation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeOutCubic,
      ),
    );
    _previousPosition = widget.currentIndex.toDouble();
  }

  @override
  void didUpdateWidget(BottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousPosition = oldWidget.currentIndex.toDouble();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('assets/icons/rewards.png', 0),
          _buildNavItem('assets/icons/home.png', 1),
          _buildNavItem('assets/icons/add_user.png', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, int index) {
    final bool isSelected = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Animated selection indicator
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double position = _previousPosition + (_animation.value * (widget.currentIndex - _previousPosition));
              return Positioned(
                top: -8,
                left: -35 + ((index - position) * 120),
                right: -35,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.elliptical(100, 8),
                    ),
                  ),
                ),
              );
            },
          ),
          // Navigation item container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: isSelected ? Matrix4.translationValues(0, -12, 0) : Matrix4.translationValues(0, 0, 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.textPrimary : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Image.asset(
                imagePath,
                width: isSelected ? 32 : 28,
                height: isSelected ? 32 : 28,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}