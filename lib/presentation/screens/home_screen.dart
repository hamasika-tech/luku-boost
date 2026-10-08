import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../config/routes.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/transaction_card.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context, controller),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _LimitCard(controller: controller),
                    const SizedBox(height: 16),
                    _StatsRow(controller: controller),
                    const SizedBox(height: 24),
                    _TrendCard(controller: controller),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Quick actions'),
                    _QuickActions(),
                    const SizedBox(height: 24),
                    SectionHeader(title: 'Recent activity'),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: Obx(() {
                return SliverList.separated(
                  itemCount: controller.transactions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    return TransactionCard(
                      transaction: controller.transactions[index],
                    );
                  },
                );
              }),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 24),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: 'home'),
    );
  }

  Widget _buildHeader(BuildContext context, HomeController controller) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to boost?',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: const Text(
              'AM',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitCard extends StatefulWidget {
  final HomeController controller;

  const _LimitCard({required this.controller});

  @override
  State<_LimitCard> createState() => _LimitCardState();
}

class _LimitCardState extends State<_LimitCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progress = Tween<double>(begin: 0, end: widget.controller.limitUsedRatio)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final used = NumberFormat('#,###').format(widget.controller.outstandingAmount.value);
    final total = NumberFormat('#,###').format(widget.controller.limitAmount.value);

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary,
                Color.lerp(scheme.primary, Colors.black, 0.25) ?? scheme.primary,
              ],
            ),
            boxShadow: AppShadows.hero(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress.value,
                        strokeWidth: 9,
                        backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
                        valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                      ),
                      AppIcons.lightning(size: 28),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Borrowing limit used',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TZS $used',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'of TZS $total available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  final HomeController controller;

  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Outstanding',
            value: Obx(() => Text(
              'TZS ${NumberFormat('#,###').format(controller.outstandingAmount.value)}',
            )),
            chip: Obx(() => StatusChip(
              label: 'Due in ${controller.dueDays.value} days',
              type: StatusType.warning,
            )),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Tokens received',
            value: Obx(() => Text(
              '${controller.totalTokens.value} total',
            )),
            chip: Obx(() => StatusChip(
              label: '${controller.monthlyTokens.value} this month',
              type: StatusType.success,
            )),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final Widget value;
  final Widget chip;

  const _StatCard({
    required this.label,
    required this.value,
    required this.chip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
              ),
              child: value,
            ),
            const SizedBox(height: 10),
            chip,
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final HomeController controller;

  const _TrendCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = [
      const FlSpot(0, 50),
      const FlSpot(1, 42),
      const FlSpot(2, 46),
      const FlSpot(3, 28),
      const FlSpot(4, 34),
      const FlSpot(5, 14),
      const FlSpot(6, 20),
      const FlSpot(7, 6),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly borrowing trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                StatusChip(
                  label: controller.trendGrowth.value,
                  type: StatusType.info,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 72,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 64,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: scheme.secondary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: scheme.secondaryContainer.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(enabled: false),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul']
                  .map((m) => Text(
                        m,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _QuickActionTile(
          icon: Icons.bolt,
          iconColor: scheme.onPrimaryContainer,
          background: scheme.primaryContainer,
          title: 'Borrow electricity',
          subtitle: 'Get a token in under a minute',
          onTap: () => Get.offAllNamed(AppRoutes.boost),
        ),
        const SizedBox(height: 10),
        _QuickActionTile(
          icon: Icons.vpn_key_outlined,
          iconColor: scheme.onSecondaryContainer,
          background: scheme.secondaryContainer,
          title: 'Retrieve last token',
          subtitle: 'Resend or view your latest token',
          onTap: () => Get.offAllNamed(AppRoutes.token),
        ),
        const SizedBox(height: 10),
        _QuickActionTile(
          icon: Icons.help_outline,
          iconColor: scheme.onTertiaryContainer,
          background: scheme.tertiaryContainer,
          title: 'How it works',
          subtitle: 'Borrowing, tokens, and repayment',
          onTap: () {},
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: background,
                foregroundColor: iconColor,
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
