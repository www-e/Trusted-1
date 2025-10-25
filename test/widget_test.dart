// Widget Tests - Basic widget tests for the app
// Tests app initialization and main widget tree

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trusted_app/main.dart';

void main() {
  testWidgets('App initializes and shows loading or auth screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const TrustedApp());
    
    // Wait for first frame
    await tester.pump();

    // Verify that the app loads
    // Should show either loading indicator or sign in screen
    expect(
      find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
          find.text('تسجيل الدخول').evaluate().isNotEmpty,
      true,
    );
  });

  testWidgets('App title is Trusted App', (WidgetTester tester) async {
    await tester.pumpWidget(const TrustedApp());
    
    // Verify MaterialApp is created with correct title
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Trusted App');
  });
}
