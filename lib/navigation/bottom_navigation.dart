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
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E293B),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'assets/icons/rewards.png'),
                _buildNavItem(1, 'assets/icons/home.png'),
                _buildNavItem(2, 'assets/icons/add_user.png'),
              ],
            ),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double position = _previousPosition + (_animation.value * (widget.currentIndex - _previousPosition));
              
              final double width = MediaQuery.of(context).size.width;
              final double itemWidth = width / 3;
              final double centerX = (position * itemWidth) + (itemWidth / 2);
              
              return Positioned(
                top: -15,
                left: centerX - 25, 
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF111827),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _getIconForIndex(widget.currentIndex),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    final bool isSelected = widget.currentIndex == index;
    

    if (isSelected) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
      );
    }
    
    return InkWell(
      onTap: () => widget.onItemTapped(index),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: Center(
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Image.asset(
          'assets/icons/rewards.png',
          width: 24,
          height: 24,
          color: const Color(0xFF111827),
        );
      case 1:
        return Image.asset(
          'assets/icons/home.png',
          width: 24,
          height: 24,
          color: const Color(0xFF111827),
        );
      case 2:
        return Image.asset(
          'assets/icons/add_user.png',
          width: 24,
          height: 24,
          color: const Color(0xFF111827),
        );
      default:
        return const SizedBox();
    }
  }
}