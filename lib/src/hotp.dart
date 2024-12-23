import 'dart:math';
import 'dart:typed_data';
import 'package:axons_otp/src/base32.dart';
import 'package:axons_otp/src/hex.dart';
import 'package:crypto/crypto.dart';

class HOTP {
  /// Generates a One-Time Password (OTP) using the HMAC One-Time Password (HOTP) algorithm.<br>
  ///
  /// [secret] The shared secret key, encoded in Base32 format, used for HMAC generation.<br>
  /// [counter] The counter value to be used for the HMAC generation.<br>
  /// [algorithm] The hash algorithm to be used for HMAC (default is SHA-1).<br>
  /// [digits] The number of digits in the generated OTP (default is 6).<br>
  /// Returns a string representation of the generated OTP.
  static String generate(
    String secret, {
    required int counter,
    Hash algorithm = sha1,
    int digits = 6,
  }) {
    final String hexCounter = counter.toRadixString(16).padLeft(16, '0');
    final Uint8List decodedSecret = Hex.decode(Base32.toHex(secret));

    Hmac hmac = Hmac(algorithm, decodedSecret);

    final Uint8List counterBytes = Hex.decode(hexCounter);
    final List<int> hash = hmac.convert(counterBytes).bytes;

    final int offsetByte = hash[hash.length - 1] & 0xf;
    final int binaryCode = ((hash[offsetByte] & 0x7f) << 24) |
        ((hash[offsetByte + 1] & 0xff) << 16) |
        ((hash[offsetByte + 2] & 0xff) << 8) |
        (hash[offsetByte + 3] & 0xff);

    final int otp = binaryCode % pow(10, digits).toInt();
    return otp.toString().padLeft(digits, '0');
  }

  /// Verifies a HMAC One-Time Password (HOTP) against the provided parameters.<br>
  ///
  /// This method checks whether the given [code] matches the expected OTP for the
  /// provided [secret] and optional parameters, allowing for a tolerance window.<br>
  ///
  /// [code] - The OTP code to verify.<br>
  /// [secret] - The shared secret key (Base32-encoded) used for generating the OTP.<br>
  /// [counter] - The counter value to be used for the HMAC generation.<br>
  /// [algorithm] - The hash algorithm used for the HMAC (default is SHA-1).<br>
  /// [digits] - The number of digits for the OTP (default is 6).<br>
  /// [tolerance] - The number of counter values to check around the current counter to account for clock drift (default is 1).<br>
  ///
  /// Returns `true` if the provided [code] matches a valid OTP within the tolerance window,
  /// otherwise returns `false`.<br>
  static bool verify(
    String code,
    String secret, {
    required int counter,
    Hash algorithm = sha1,
    int digits = 6,
    int tolerance = 1,
  }) {
    final currentToken = generate(
      secret,
      counter: counter,
      algorithm: algorithm,
      digits: digits,
    );

    if (currentToken == code) return true;

    for (var i = 1; i < tolerance; i++) {
      if (code ==
              generate(
                secret,
                counter: counter + i,
                algorithm: algorithm,
                digits: digits,
              ) ||
          code ==
              generate(
                secret,
                counter: counter - i,
                algorithm: algorithm,
                digits: digits,
              )) {
        return true;
      }
    }

    return false;
  }
}
