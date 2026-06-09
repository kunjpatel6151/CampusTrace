// Basic smoke test for CampusTrace app.

import 'package:flutter_test/flutter_test.dart';

import 'package:campus_trace/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusTraceApp());

    // Verify that the splash screen renders with the app name.
    expect(find.text('CampusTrace'), findsOneWidget);
  });
}
