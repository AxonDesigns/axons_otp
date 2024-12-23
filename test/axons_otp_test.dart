import 'package:axons_otp/axons_otp.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    //final secret = Base32.random(length: 32);
    String token = '';

    setUp(() {});

    test('generate base32 token', () {
      token = Base32.random(length: 32);
      print(token);
    });

    test('generate otp', () {
      final otp = TOTP.generate(token);
      print(otp);
      expect(otp, isNotEmpty);
      expect(otp.length, 6);
    });

    test('verify otp', () {
      final otp = TOTP.generate(token);
      final verified = TOTP.verify(otp, token);
      print(verified);
      expect(verified, true);
    });
  });
}
