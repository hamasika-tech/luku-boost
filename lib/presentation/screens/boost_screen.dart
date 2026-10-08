import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_topbar.dart';
import '../../core/widgets/amount_chip.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/meter_details_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/skeleton_card.dart';
import '../controllers/boost_controller.dart';

class BoostScreen extends StatefulWidget {
  const BoostScreen({super.key});

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BoostController>().startBoost();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoostController>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppTopBar(
        title: '',
        onBack: controller.back,
      ),
      body: Obx(() {
        return Column(
          children: [
            _StepProgress(controller: controller),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.03, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  key: ValueKey(controller.currentStep.value),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: _stepBody(controller),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const AppBottomNav(activeTab: 'boost'),
    );
  }

  Widget _stepBody(BoostController controller) {
    switch (controller.currentStep.value) {
      case BoostStep.verify:
        return const _VerifyStep();
      case BoostStep.amount:
        return const _AmountStep();
      case BoostStep.confirm:
        return const _ConfirmStep();
      case BoostStep.success:
        return const _SuccessStep();
    }
  }
}

class _StepProgress extends StatelessWidget {
  final BoostController controller;

  const _StepProgress({required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = BoostStep.values;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: List.generate(steps.length, (index) {
          final active = index <= controller.currentStep.value.index;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: active ? scheme.primary : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _VerifyStep extends StatefulWidget {
  const _VerifyStep();

  @override
  State<_VerifyStep> createState() => _VerifyStepState();
}

class _VerifyStepState extends State<_VerifyStep> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _meterController = TextEditingController();

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'Enter a valid mobile number.';
    return null;
  }

  String? _validateMeter(String? value) {
    if ((value ?? '').length < 8) return 'Meter number not found. Double-check the digits.';
    return null;
  }

  void _submit() {
    final controller = Get.find<BoostController>();
    if (_formKey.currentState?.validate() ?? false) {
      controller.submitDetails(_phoneController.text.trim(), _meterController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<BoostController>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter your mobile number and meter number. We'll verify both and fetch your account details.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Mobile number',
              hintText: 'e.g. 0712 345 678',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _meterController,
            keyboardType: TextInputType.number,
            validator: _validateMeter,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              labelText: 'Meter number',
              hintText: 'e.g. 04821093456',
              prefixIcon: Icon(Icons.electric_meter_outlined),
            ),
          ),
          const SizedBox(height: 32),
          Obx(() => SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: controller.isLoading.value ? null : _submit,
              icon: controller.isLoading.value
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: scheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.bolt),
              label: Text(controller.isLoading.value ? 'Verifying...' : 'Power Boost'),
            ),
          )),
        ],
      ),
    );
  }
}

class _AmountStep extends StatefulWidget {
  const _AmountStep();

  @override
  State<_AmountStep> createState() => _AmountStepState();
}

class _AmountStepState extends State<_AmountStep> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<BoostController>().fetchMeterDetails();
  }

  void _quickAmount(int value) {
    _amountController.text = NumberFormat('#,###').format(value);
  }

  void _continue() {
    Get.find<BoostController>().submitAmount(_amountController.text);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoostController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SkeletonCard(hasLeading: true, lineCount: 3);
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return ErrorState(
          icon: Icons.wifi_tethering_error_rounded,
          title: 'Unable to verify meter',
          description: controller.errorMessage.value,
          actionLabel: 'Try Again',
          onAction: () => controller.goToStep(BoostStep.verify),
        );
      }

      final customer = controller.customer.value;
      if (customer == null) {
        return const SkeletonCard(hasLeading: true, lineCount: 3);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MeterDetailsCard(customer: customer),
          const SizedBox(height: 24),
          SectionHeader(title: 'Choose amount'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [5000, 10000, 20000].map((v) {
              final selected = _amountController.text.replaceAll(RegExp(r'\D'), '') == v.toString();
              return AmountChip(
                amount: v,
                selected: selected,
                onSelected: (value) => _quickAmount(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Or enter custom amount (TZS)',
              hintText: 'e.g. 10,000',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _continue,
              child: const Text('Continue'),
            ),
          ),
        ],
      );
    });
  }
}

class _ConfirmStep extends StatefulWidget {
  const _ConfirmStep();

  @override
  State<_ConfirmStep> createState() => _ConfirmStepState();
}

class _ConfirmStepState extends State<_ConfirmStep> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<BoostController>();

    final fee = (controller.amount.value * 0.01).round();
    final total = controller.amount.value + fee;

    return Obx(() {
      final confirmEnabled = _otpController.text.length == 4 && !controller.isLoading.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review your details, then enter the code we sent to confirm.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(label: 'Mobile number', value: controller.phone.value),
                  _SummaryRow(label: 'Meter number', value: controller.meter.value),
                  _SummaryRow(label: 'Customer', value: controller.customer.value?.name ?? ''),
                  _SummaryRow(
                    label: 'Borrow amount',
                    value: 'TZS ${NumberFormat('#,###').format(controller.amount.value)}',
                  ),
                  _SummaryRow(
                    label: 'Processing fee',
                    value: 'TZS ${NumberFormat('#,###').format(fee)}',
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'Estimated repayment',
                    value: 'TZS ${NumberFormat('#,###').format(total)}',
                    bold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'OTP code',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sent to ${controller.phone.value}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _otpController,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 4,
            onChanged: (_) => setState(() {}),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              letterSpacing: 12,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              hintText: '••••',
              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                letterSpacing: 12,
                color: scheme.onSurfaceVariant,
              ),
              errorText: controller.errorMessage.value.isNotEmpty ? controller.errorMessage.value : null,
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.canResendOtp.value
                    ? 'Didn\'t receive it?'
                    : 'Resend in 00:${controller.otpTimer.value.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: controller.canResendOtp.value ? controller.resendOtp : null,
                child: const Text('Resend code'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: confirmEnabled
                  ? () {
                      controller.otp.value = _otpController.text;
                      controller.confirmBoost();
                    }
                  : null,
              icon: controller.isLoading.value
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: scheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.bolt),
              label: Text(controller.isLoading.value ? 'Boosting...' : 'Boost power'),
            ),
          ),
        ],
      );
    });
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<BoostController>();

    return Column(
      children: [
        const SizedBox(height: 16),
        _SuccessIcon(),
        const SizedBox(height: 24),
        Text(
          'Power Boost successful',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your token was sent to your phone and by SMS.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOKEN NUMBER',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Copy'),
                    ),
                  ],
                ),
                SelectableText(
                  controller.tokenResult.value?.tokenNumber ?? '4821 0937 5610 2298',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'Borrowed amount',
                  value: 'TZS ${NumberFormat('#,###').format(controller.amount.value)}',
                ),
                _SummaryRow(
                  label: 'Meter number',
                  value: controller.meter.value,
                ),
                _SummaryRow(
                  label: 'Date',
                  value: DateFormat('MMM d, y').format(DateTime.now()),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => controller.back(),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}

class _SuccessIcon extends StatefulWidget {
  @override
  State<_SuccessIcon> createState() => _SuccessIconState();
}

class _SuccessIconState extends State<_SuccessIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
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

    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          size: 48,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
              style: bold
                  ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    )
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
