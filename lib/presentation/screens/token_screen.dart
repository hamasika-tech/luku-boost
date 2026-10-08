import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_topbar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/skeleton_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../domain/models/token.dart';
import '../controllers/token_controller.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meterController = TextEditingController();

  String? _validateMeter(String? value) {
    if ((value ?? '').length < 8) return 'Enter a valid meter number.';
    return null;
  }

  void _fetch() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.find<TokenController>().fetchToken(_meterController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<TokenController>();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: const AppTopBar(title: 'Retrieve Token'),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your meter number to retrieve the most recent token sent to it.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _meterController,
                    keyboardType: TextInputType.number,
                    validator: _validateMeter,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) => _fetch(),
                    decoration: const InputDecoration(
                      labelText: 'Meter number',
                      hintText: 'e.g. 04821093456',
                      prefixIcon: Icon(Icons.electric_meter_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: controller.isLoading.value ? null : _fetch,
                    icon: controller.isLoading.value
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(controller.isLoading.value ? 'Retrieving...' : 'Get token'),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildResult(context, controller),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const AppBottomNav(activeTab: 'token'),
    );
  }

  Widget _buildResult(BuildContext context, TokenController controller) {
    if (controller.isLoading.value) {
      return const SkeletonCard(hasLeading: false, lineCount: 3);
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return ErrorState(
        icon: Icons.signal_wifi_connected_no_internet_4,
        title: controller.errorMessage.value.contains('network') ? 'Network unavailable' : 'Unable to retrieve token',
        description: controller.errorMessage.value,
        actionLabel: 'Try Again',
        onAction: _fetch,
      );
    }

    final token = controller.tokenResult.value;
    if (token == null) {
      return EmptyState(
        icon: Icons.key_off_outlined,
        title: 'No token retrieved yet',
        description: 'Enter a meter number above and we\'ll pull up the latest token sent to it.',
      );
    }

    return _TokenResultCard(token: token, onRefresh: _fetch);
  }
}

class _TokenResultCard extends StatelessWidget {
  final TokenResult token;
  final VoidCallback onRefresh;

  const _TokenResultCard({required this.token, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                  'LAST TOKEN',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const StatusChip(label: 'Delivered', type: StatusType.success),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              token.tokenNumber,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const Divider(height: 28),
            _SummaryRow(label: 'Meter number', value: token.meterNumber),
            _SummaryRow(label: 'Generated', value: DateFormat('MMM d, y').format(token.generatedAt)),
            _SummaryRow(
              label: 'Borrow amount',
              value: 'TZS ${NumberFormat('#,###').format(token.borrowAmount)}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
