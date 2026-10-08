import 'package:get/get.dart';
import '../../domain/models/token.dart';
import '../../data/services/boost_service.dart';

class TokenController extends GetxController {
  final BoostService _service = BoostService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final tokenResult = Rxn<TokenResult>();

  Future<void> fetchToken(String meterNumber) async {
    if (meterNumber.length < 8) {
      errorMessage.value = 'Enter a valid meter number.';
      tokenResult.value = null;
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    tokenResult.value = null;

    try {
      final result = await _service.fetchLatestToken(meterNumber);
      tokenResult.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      tokenResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    errorMessage.value = '';
    tokenResult.value = null;
  }
}
