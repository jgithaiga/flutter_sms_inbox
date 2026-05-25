// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sms_inbox_example/main.dart';

void main() {
  testWidgets('Shows initial empty-state UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('SMS Inbox Example'), findsOneWidget);
    expect(find.textContaining('No messages to show.'), findsOneWidget);
    expect(find.byTooltip('Show message body (debug)'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
