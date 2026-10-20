// Генерує PNG-скриншоти екранів для звіту:
//   flutter test tool/screenshots_test.dart --update-goldens
import 'dart:io';

import 'package:boardhub/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFonts() async {
  final fontsDir = Directory(
    '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts',
  );
  final roboto = FontLoader('Roboto');
  for (final weight in ['regular', 'medium', 'bold', 'black']) {
    final bytes = File('${fontsDir.path}/roboto-$weight.ttf').readAsBytesSync();
    roboto.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      Future.value(
        ByteData.sublistView(
          File('${fontsDir.path}/materialicons-regular.otf').readAsBytesSync(),
        ),
      ),
    );
  await icons.load();
}

const _desktop = Size(1440, 900);
const _mobile = Size(390, 844);

Future<void> _shot(
  WidgetTester tester,
  String name,
  Size size,
  Future<void> Function() steps,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  await tester.pumpWidget(const BoardHubApp());
  await tester.pumpAndSettle();
  await steps();
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../screenshots/$name.png'),
  );
  tester.view.reset();
}

void main() {
  setUpAll(_loadFonts);

  for (final (label, size) in [('desktop', _desktop), ('mobile', _mobile)]) {
    testWidgets(
      'login $label',
      (t) => _shot(t, '01_login_$label', size, () async {}),
    );
    testWidgets(
      'reset $label',
      (t) => _shot(t, '02_reset_password_$label', size, () async {
        await t.tap(find.text('Forgot password?'));
      }),
    );
    testWidgets(
      'register $label',
      (t) => _shot(t, '03_register_$label', size, () async {
        await t.tap(find.text('Create account'));
      }),
    );
    testWidgets(
      'home $label',
      (t) => _shot(t, '04_home_$label', size, () async {
        await t.tap(find.text('Log In'));
      }),
    );
    testWidgets(
      'profile $label',
      (t) => _shot(t, '05_profile_$label', size, () async {
        await t.tap(find.text('Log In'));
        await t.pumpAndSettle();
        await t.tap(find.text('Profile').last);
      }),
    );
  }
}
