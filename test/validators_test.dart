import 'package:boardhub/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email', () {
    expect(Validators.email(''), isNotNull);
    expect(Validators.email('user@mail'), isNotNull);
    expect(Validators.email('user@mail.com'), isNull);
  });

  test('name', () {
    expect(Validators.name('  '), isNotNull);
    expect(Validators.name('A'), isNotNull);
    expect(Validators.name('Володимир'), isNull);
    expect(Validators.name('<script>'), isNotNull);
  });

  test('new password and confirmation', () {
    expect(Validators.newPassword('abc12'), isNotNull);
    expect(Validators.newPassword('abcdefgh'), isNotNull);
    expect(Validators.newPassword('abcdef12'), isNull);
    final confirm = Validators.confirmPassword(() => 'abcdef12');
    expect(confirm('abcdef13'), isNotNull);
    expect(confirm('abcdef12'), isNull);
  });

  test('https image url', () {
    expect(Validators.httpsImageUrl('http://a.com/x.png'), isNotNull);
    expect(Validators.httpsImageUrl('not a url'), isNotNull);
    expect(Validators.httpsImageUrl('https://a.com/x.png'), isNull);
  });
}
