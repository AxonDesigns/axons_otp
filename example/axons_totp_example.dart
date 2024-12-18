import 'package:axons_totp/axons_totp.dart';

void main() {
  final String secret = 'JBSWY3DPEHPK3PXP';
  final String otp = TOTP.generate(secret);
  print('OTP: $otp');

  if (TOTP.verify(otp, secret)) {
    print('Verified!');
  } else {
    print('Not verified!');
  }
}
