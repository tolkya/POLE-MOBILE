import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pole_mobile/main.dart';

void main() {
  testWidgets('Shows auth demo screen when splash is disabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(
          showSplash: false,
          enableSessionRestore: false,
        ),
      ),
    );

    expect(find.text('Sparklib Mobile - Auth Test'), findsOneWidget);
    expect(find.text('Login + GET /me'), findsOneWidget);
  });
}
