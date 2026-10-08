import 'package:flutter_test/flutter_test.dart';
import 'package:luku/app.dart';

void main() {
  testWidgets('App shows splash and navigates to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const LukuBoostApp());

    expect(find.text('Luku Boost'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Borrow instantly'), findsOneWidget);
  });
}
