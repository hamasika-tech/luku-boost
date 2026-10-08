import 'package:get/get.dart';
import '../presentation/bindings/app_binding.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/boost_screen.dart';
import '../presentation/screens/token_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/design_system_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String boost = '/boost';
  static const String token = '/token';
  static const String settings = '/settings';
  static const String designSystem = '/design-system';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: boost,
      page: () => const BoostScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: token,
      page: () => const TokenScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: designSystem,
      page: () => const DesignSystemScreen(),
      binding: AppBinding(),
    ),
  ];
}
