import 'package:boardhub/app.dart';
import 'package:boardhub/core/di/app_scope.dart';
import 'package:boardhub/features/auth/data/auth_repository.dart';
import 'package:boardhub/features/profile/data/profile_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void _setScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// Користувач із прив'язаними способами входу [providers].
MockUser _newUser({List<String> providers = const ['password']}) => MockUser(
  uid: 'u1',
  email: 'vova@example.com',
  displayName: 'Vova',
  providerData: [
    for (final id in providers)
      UserInfo.fromPigeon(
        InternalUserInfo(
          uid: 'u1',
          email: 'vova@example.com',
          providerId: id,
          isAnonymous: false,
          isEmailVerified: true,
        ),
      ),
  ],
);

Future<MockFirebaseAuth> _pumpApp(
  WidgetTester tester, {
  bool signedIn = false,
  List<String> providers = const ['password'],
}) async {
  final auth = MockFirebaseAuth(
    mockUser: _newUser(providers: providers),
    signedIn: signedIn,
  );
  await tester.pumpWidget(
    BoardHubApp(
      services: AppServices(
        authRepository: AuthRepository(auth),
        profileRepository: ProfileRepository(auth),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return auth;
}

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(TextFormField),
);

void main() {
  testWidgets('Login form validates fields before sending', (tester) async {
    _setScreenSize(tester, const Size(1440, 900));
    await _pumpApp(tester);

    await tester.tap(find.text('Log In'));
    await tester.pump();
    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(_field('Email'), 'not-an-email');
    await tester.tap(find.text('Log In'));
    await tester.pump();
    expect(
      find.text('Enter a valid email, e.g. you@example.com.'),
      findsOneWidget,
    );
  });

  testWidgets('Failed login shows a readable error', (tester) async {
    _setScreenSize(tester, const Size(1440, 900));
    final auth = await _pumpApp(tester);
    whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
        .on(auth)
        .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

    await tester.enterText(_field('Email'), 'vova@example.com');
    await tester.enterText(_field('Password'), 'wrong-pass');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(
      find.text("Couldn't log in. Check your email and password."),
      findsOneWidget,
    );
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Successful login opens the dashboard', (tester) async {
    _setScreenSize(tester, const Size(1440, 900));
    await _pumpApp(tester);

    await tester.enterText(_field('Email'), 'vova@example.com');
    await tester.enterText(_field('Password'), 'secret123');
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Total games'), findsOneWidget);
    expect(find.textContaining('Vova.'), findsOneWidget);
    expect(find.text('Signed in as vova@example.com.'), findsOneWidget);
  });

  testWidgets('Registration form checks name, email and passwords', (
    tester,
  ) async {
    _setScreenSize(tester, const Size(1440, 1100));
    await _pumpApp(tester);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Email'), 'vova@example');
    await tester.enterText(_field('Password'), 'short');
    await tester.enterText(_field('Confirm password'), 'other');
    await tester.tap(find.text('Create Account'));
    await tester.pump();

    expect(find.text('Enter your name.'), findsOneWidget);
    expect(
      find.text('Enter a valid email, e.g. you@example.com.'),
      findsOneWidget,
    );
    expect(
      find.text('Password must be at least 8 characters.'),
      findsOneWidget,
    );
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('Restored session shows profile and logs out on mobile', (
    tester,
  ) async {
    _setScreenSize(tester, const Size(390, 844));
    await _pumpApp(tester, signedIn: true);

    expect(find.text('Session restored. Welcome back, Vova!'), findsOneWidget);
    // Чекаємо, поки сповіщення зникне і не перекриватиме кнопки.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('vova@example.com'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Log out'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('You have been logged out.'), findsOneWidget);
  });

  testWidgets('Google sign-in opens the dashboard', (tester) async {
    _setScreenSize(tester, const Size(1440, 1000));
    await _pumpApp(tester, providers: ['google.com']);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Total games'), findsOneWidget);
  });

  testWidgets('Profile shows sign-in methods and offers to link Google', (
    tester,
  ) async {
    _setScreenSize(tester, const Size(1440, 1400));
    await _pumpApp(tester, signedIn: true);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(find.text('Sign-in methods'), findsOneWidget);
    expect(find.text('Link Google'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);
  });

  testWidgets('Google-only account has no password form', (tester) async {
    _setScreenSize(tester, const Size(1440, 1400));
    await _pumpApp(tester, signedIn: true, providers: ['google.com']);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    expect(find.text('Update Password'), findsNothing);
    expect(find.text('Link Google'), findsNothing);
    expect(find.textContaining('uses Google sign-in'), findsOneWidget);
  });
}
