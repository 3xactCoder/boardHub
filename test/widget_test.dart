import 'package:boardhub/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void _setScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Log In opens the dashboard', (tester) async {
    _setScreenSize(tester, const Size(1440, 900));
    await tester.pumpWidget(const BoardHubApp());

    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Total games'), findsOneWidget);
    expect(find.text('Record Match'), findsOneWidget);
  });

  testWidgets('Mobile layout shows bottom navigation', (tester) async {
    _setScreenSize(tester, const Size(390, 844));
    await tester.pumpWidget(const BoardHubApp());

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);
  });
}
