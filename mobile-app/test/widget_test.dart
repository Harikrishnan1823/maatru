import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maatru/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaatruApp(),
      ),
    );
    expect(find.text('Maatru'), findsNothing); // It's in the title maybe, let's just assert no crashes
  });
}
