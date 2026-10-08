import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class SettingsController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  final appVersion = '2.4.1'.obs;

  void setTheme(ThemeMode mode) {
    themeController.setThemeMode(mode);
  }
}
