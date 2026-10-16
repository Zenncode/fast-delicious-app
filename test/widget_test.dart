import 'package:flutter_test/flutter_test.dart';
import 'package:fast_delicious_food_app/main.dart';

void main() {
  testWidgets('Renders Fast and Delicious Food home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FastDeliciousFoodApp());
    expect(find.textContaining('Fast and'), findsOneWidget);
    expect(find.text('Sake Roll'), findsWidgets);
  });
}
