import 'dart:async';
import 'package:get/get.dart';
import '../../config/routes.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/token.dart';
import '../../data/services/boost_service.dart';

enum BoostStep { verify, amount, confirm, success }

class BoostController extends GetxController {
  final BoostService _service = BoostService();

  final currentStep = BoostStep.verify.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final phone = ''.obs;
  final meter = ''.obs;
  final amount = 0.obs;
  final otp = ''.obs;
  final customer = Rxn<Customer>();

  final otpTimer = 30.obs;
  final canResendOtp = false.obs;
  Timer? _otpTimer;

  final tokenResult = Rxn<TokenResult>();

  final List<String> stepTitles = [
    'Verify details',
    'Borrow amount',
    'Confirm & boost',
    'Success',
  ];

  String get title => stepTitles[currentStep.value.index];

  void startBoost() {
    currentStep.value = BoostStep.verify;
    isLoading.value = false;
    errorMessage.value = '';
    phone.value = '';
    meter.value = '';
    amount.value = 0;
    otp.value = '';
    customer.value = null;
    tokenResult.value = null;
    _otpTimer?.cancel();
    canResendOtp.value = false;
    otpTimer.value = 30;
  }

  void goToStep(BoostStep step) {
    currentStep.value = step;
    errorMessage.value = '';
  }

  void back() {
    switch (currentStep.value) {
      case BoostStep.verify:
        Get.offAllNamed(AppRoutes.home);
        break;
      case BoostStep.amount:
        goToStep(BoostStep.verify);
        break;
      case BoostStep.confirm:
        goToStep(BoostStep.amount);
        break;
      case BoostStep.success:
        break;
    }
  }

  Future<void> submitDetails(String phoneInput, String meterInput) async {
    final phoneDigits = phoneInput.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 9) {
      errorMessage.value = 'Enter a valid mobile number.';
      return;
    }
    if (meterInput.length < 8) {
      errorMessage.value = 'Meter number not found. Double-check the digits.';
      return;
    }

    phone.value = phoneInput;
    meter.value = meterInput;
    errorMessage.value = '';
    goToStep(BoostStep.amount);
  }

  Future<void> fetchMeterDetails() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.verifyMeter(meter.value, phone.value);
      customer.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAmount(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final parsed = int.tryParse(digits);
    final limit = customer.value?.limit ?? 0;

    if (parsed == null || parsed <= 0) {
      errorMessage.value = 'Enter an amount to continue.';
      return;
    }
    if (parsed > limit) {
      errorMessage.value =
          'That\'s above your available limit of TZS ${limit.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}.';
      return;
    }

    amount.value = parsed;
    errorMessage.value = '';
    goToStep(BoostStep.confirm);
    startOtpTimer();
    await _service.requestOtp(phone.value);
  }

  void startOtpTimer() {
    canResendOtp.value = false;
    otpTimer.value = 30;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value <= 1) {
        canResendOtp.value = true;
        timer.cancel();
      } else {
        otpTimer.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResendOtp.value) return;
    await _service.requestOtp(phone.value);
    startOtpTimer();
  }

  Future<void> confirmBoost() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.confirmBoost(
        phone: phone.value,
        meter: meter.value,
        amount: amount.value,
        otp: otp.value,
      );
      tokenResult.value = result;
      goToStep(BoostStep.success);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }
}
