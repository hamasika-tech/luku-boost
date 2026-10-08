import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/controllers/theme_controller.dart';

class LukuBoostApp extends StatelessWidget {
  const LukuBoostApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController(), permanent: true);

    return Obx(() {
      return GetMaterialApp(
        title: 'Luku Boost',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 250),
      );
    });
  }
}
