// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cocoa_token_front/main.dart'; // Usar importación de paquete
import 'package:cocoa_token_front/layouts/main_layout.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial loading screen is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that we're on the main layout
    expect(find.byType(MainLayout), findsOneWidget);
  });
}
