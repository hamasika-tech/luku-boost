import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';

class AppBottomNav extends StatelessWidget {
  final String activeTab;

  const AppBottomNav({super.key, required this.activeTab});

  int get _index {
    switch (activeTab) {
      case 'home':
        return 0;
      case 'boost':
        return 1;
      case 'token':
        return 2;
      case 'settings':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: _onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
          tooltip: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.bolt_outlined),
          selectedIcon: Icon(Icons.bolt),
          label: 'Boost',
          tooltip: 'Borrow electricity',
        ),
        NavigationDestination(
          icon: Icon(Icons.vpn_key_outlined),
          selectedIcon: Icon(Icons.vpn_key),
          label: 'Token',
          tooltip: 'Retrieve token',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
          tooltip: 'Settings',
        ),
      ],
    );
  }

  void _onDestinationSelected(int index) {
    final routes = [
      AppRoutes.home,
      AppRoutes.boost,
      AppRoutes.token,
      AppRoutes.settings,
    ];
    final target = routes[index];
    if (target == activeTab) return;
    Get.offAllNamed(target);
  }
}
