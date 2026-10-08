import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/boost_controller.dart';
import '../controllers/token_controller.dart';
import '../controllers/settings_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<BoostController>(BoostController(), permanent: true);
    Get.put<TokenController>(TokenController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
  }
}
