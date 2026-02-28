import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_hackathon/app/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const PageCraftApp());
    expect(find.text('AI PageGen'), findsOneWidget);
  });
}
