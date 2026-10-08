import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _SectionTitle(title: 'Appearance'),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ThemeSelector(controller: controller),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ColorPreview(),
                  ],
                ),
              ),
              _SectionTitle(title: 'Support'),
              _SettingsGroup(
                items: [
                  _SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help centre',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.menu_book_outlined,
                    title: 'User guide',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Frequently asked questions',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              _SectionTitle(title: 'Legal'),
              _SettingsGroup(
                items: [
                  _SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy policy',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & conditions',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              _SectionTitle(title: 'About'),
              _SettingsGroup(
                items: [
                  _SettingsItem(
                    icon: Icons.info_outline,
                    title: 'App version',
                    trailing: controller.appVersion.value,
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.mail_outline,
                    title: 'Contact support',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.palette_outlined,
                    title: 'View design system (dev)',
                    onTap: () => Get.toNamed(AppRoutes.designSystem),
                    showDivider: false,
                    textColor: scheme.primary,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: 'settings'),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final SettingsController controller;

  const _ThemeSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = controller.themeController.themeMode;

    return ListTile(
      leading: Icon(Icons.brightness_6_outlined, color: scheme.onSurfaceVariant),
      title: const Text('Theme mode'),
      subtitle: Text(
        'Light, dark, or match system',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(value: ThemeMode.light, label: Text('Light')),
          ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
          ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
        ],
        selected: {theme},
        onSelectionChanged: (selected) {
          final mode = selected.first;
          controller.setTheme(mode);
        },
        showSelectedIcon: false,
      ),
    );
  }
}

class _ColorPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(Icons.color_lens_outlined, color: scheme.onSurfaceVariant),
      title: const Text('Theme colour'),
      subtitle: Text(
        'Energy green',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _colorDot(AppColors.primary, selected: true),
          const SizedBox(width: 10),
          _colorDot(AppColors.secondary),
          const SizedBox(width: 10),
          _colorDot(AppColors.accent),
        ],
      ),
    );
  }

  Widget _colorDot(Color color, {bool selected = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.black : Colors.transparent,
          width: selected ? 2 : 0,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;

  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: item.icon != null
                    ? Icon(item.icon, color: item.textColor ?? Theme.of(context).colorScheme.onSurfaceVariant)
                    : null,
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: item.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: item.trailing != null
                    ? Text(
                        item.trailing!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: item.onTap,
              ),
              if (item.showDivider && index < items.length - 1)
                const Divider(height: 1, indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData? icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? textColor;

  _SettingsItem({
    this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.textColor,
  });
}
