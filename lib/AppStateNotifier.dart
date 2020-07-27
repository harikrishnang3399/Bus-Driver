import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isDarkMode = true;
  void updateTheme(bool isAppDarkMode) {
    this.isDarkMode = isAppDarkMode;
    notifyListeners();
  }
}
