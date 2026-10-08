import 'package:http/http.dart' as http;
import '../../domain/models/customer.dart';
import '../../domain/models/token.dart';

class BoostService {
  final http.Client _client = http.Client();

  http.Client get client => _client;

  Future<Customer?> verifyMeter(String meterNumber, String phone) async {
    // Simulate network latency.
    await Future.delayed(const Duration(milliseconds: 900));

    // Demo guard: meter numbers starting with '0' are treated as not found.
    if (meterNumber.startsWith('0')) {
      throw Exception('Meter number not found');
    }

    return const Customer(
      name: 'Amina Mwakalinga',
      type: 'Prepaid — Residential',
      limit: 35000,
    );
  }

  Future<bool> requestOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  Future<TokenResult> confirmBoost({
    required String phone,
    required String meter,
    required int amount,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1100));

    if (otp != '1234') {
      throw Exception('Invalid OTP');
    }

    return TokenResult(
      tokenNumber: '4821 0937 5610 2298',
      meterNumber: meter,
      generatedAt: DateTime(2026, 7, 20),
      borrowAmount: amount,
      status: 'Delivered',
    );
  }

  Future<TokenResult?> fetchLatestToken(String meterNumber) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Demo guard: simulate a network failure for meter numbers starting with '0'.
    if (meterNumber.startsWith('0')) {
      throw Exception('Service temporarily unavailable');
    }

    return TokenResult(
      tokenNumber: '4821 0937 5610 2298',
      meterNumber: meterNumber,
      generatedAt: DateTime(2026, 7, 14),
      borrowAmount: 5000,
      status: 'Delivered',
    );
  }
}
