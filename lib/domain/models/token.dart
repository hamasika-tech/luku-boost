class TokenResult {
  final String tokenNumber;
  final String meterNumber;
  final DateTime generatedAt;
  final int borrowAmount;
  final String status;

  const TokenResult({
    required this.tokenNumber,
    required this.meterNumber,
    required this.generatedAt,
    required this.borrowAmount,
    required this.status,
  });
}
