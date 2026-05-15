import 'package:flutter_test/flutter_test.dart';

import 'package:fellow4u/main.dart';

void main() {
  testWidgets('app renders sign in screen', (WidgetTester tester) async {
    await tester.pumpWidget(const Fellow4UApp());

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);
  });
}
