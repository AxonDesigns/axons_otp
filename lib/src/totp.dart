import 'package:axons_otp/src/hotp.dart';
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
    return HOTP.generate(
      secret,
      counter: getTimeCounter(
        dateTime: dateTime,
        offset: offset,
        period: period,
      ),
      algorithm: algorithm,
      digits: digits,
    );
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
    return HOTP.verify(
      code,
      secret,
      counter: getTimeCounter(
        dateTime: dateTime,
        offset: offset,
        period: period,
      ),
      algorithm: algorithm,
      digits: digits,
      tolerance: tolerance,
    );
  }

  /// Returns the current time counter value based on the provided parameters.
  ///
  /// [dateTime] - An optional DateTime object to override the current time (default is the system's current time).<br>
  /// [offset] - An offset in seconds to adjust the time counter (default is 0).<br>
  /// [period] - The time period in seconds for OTP validity (default is 30 seconds).<br>
  /// Returns the current time counter value.
  static int getTimeCounter({
    DateTime? dateTime,
    int offset = 0,
    int period = 30,
  }) {
    final effectiveDateTime = dateTime ?? DateTime.now();
    final seconds = (effectiveDateTime.millisecondsSinceEpoch ~/ 1000) + offset;
    return seconds ~/ period;
  }
}
