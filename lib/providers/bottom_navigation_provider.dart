import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 1;
  PageController? _pageController;

  int get currentIndex => _currentIndex;
  PageController? get pageController => _pageController;

  void setPageController(PageController controller) {
    _pageController = controller;
    notifyListeners();
  }

  void updateIndex(int index) {
    _currentIndex = index;
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
