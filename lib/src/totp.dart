import 'dart:math';
import 'dart:typed_data';
import 'package:axons_totp/src/base32.dart';
import 'package:axons_totp/src/hex.dart';
import 'package:crypto/crypto.dart';

class TOTP {
  /// Generates a One-Time Password (OTP) using the Time-based One-Time Password (TOTP) algorithm.
  ///
  /// [secret] The shared secret key, encoded in Base32 format, used for HMAC generation.<br>
  /// [algorithm] The hash algorithm to be used for HMAC (default is SHA-1).<br>
  /// [digits] The number of digits in the generated OTP (default is 6).<br>
  /// [period] The time period in seconds for OTP validity (default is 30 seconds).<br>
  /// [offset] An offset in seconds to adjust the time counter (default is 0).<br>
  /// [dateTime] An optional DateTime object to override the current time (default is the system's current time).<br>
  /// Returns a string representation of the generated OTP.
  static String generate(
    String secret, {
    Hash algorithm = sha1,
    int digits = 6,
    int period = 30,
    int offset = 0,
    DateTime? dateTime,
  }) {
    final effectiveDateTime = dateTime ?? DateTime.now();
    final seconds = (effectiveDateTime.millisecondsSinceEpoch ~/ 1000) + offset;
    final int timeCounter = seconds ~/ period;
    final String hexCounter = timeCounter.toRadixString(16).padLeft(16, '0');

    // Decode secret and convert to bytes
    final Uint8List decodedSecret = Hex.decode(Base32.toHex(secret));

    // Create HMAC
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

  /// Verifies a Time-based One-Time Password (TOTP) against the provided parameters.<br>
  ///
  /// This method checks whether the given [code] matches the expected OTP for the
  /// provided [secret] and optional parameters, allowing for a tolerance window.<br>
  ///
  /// [code] - The OTP code to verify.<br>
  /// [secret] - The shared secret key (Base32-encoded) used for generating the OTP.<br>
  /// [algorithm] - The hash algorithm used for the HMAC (default is SHA-1).<br>
  /// [digits] - The number of digits for the OTP (default is 6).<br>
  /// [period] - The time period in seconds for which the OTP is valid (default is 30 seconds).<br>
  /// [tolerance] - The number of periods to check around the current time to account for clock drift (default is 1).<br>
  /// [offset] - An optional offset (in seconds) added to the current time for syncing purposes.<br>
  /// [dateTime] - An optional custom date-time to use instead of the current system time.<br>
  ///
  /// Returns `true` if the provided [code] matches a valid OTP within the tolerance window,
  /// otherwise returns `false`.<br>
  static bool verify(
    String code,
    String secret, {
    Hash algorithm = sha1,
    int digits = 6,
    int period = 30,
    int tolerance = 1,
    int offset = 0,
    DateTime? dateTime,
  }) {
    final currentToken = generate(
      secret,
      algorithm: algorithm,
      digits: digits,
      period: period,
      offset: offset,
      dateTime: dateTime,
    );

    if (currentToken == code) return true;

    for (var i = 1; i < tolerance; i++) {
      if (code ==
              generate(
                secret,
                algorithm: algorithm,
                digits: digits,
                period: period,
                offset: offset + (i),
                dateTime: dateTime,
              ) ||
          code ==
              generate(
                secret,
                algorithm: algorithm,
                digits: digits,
                period: period,
                offset: offset + (-i),
                dateTime: dateTime,
              )) {
        return true;
      }
    }

    return false;
  }
}
