import 'package:flutter/material.dart';

mixin FormControllerMixin<T extends StatefulWidget> on State<T> {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController();
    }
    return _controllers[key]!;
  }

  void disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
