// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:energy_game/main.dart';

void main() {
  testWidgets('Landing page shows categories', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the landing page shows 'Environment & Energy' category
    expect(find.text('Environment & Energy'), findsOneWidget);
    
    // Verify that there are multiple categories
    expect(find.byType(Card), findsAtLeast(6));
  });
}
