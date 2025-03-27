import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
