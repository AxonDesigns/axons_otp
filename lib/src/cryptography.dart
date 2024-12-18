import 'package:encrypt/encrypt.dart';

class Cryptography {
  /// Encrypts a string into an encrypted base64 string
  static String encrypt(String value, String secret) {
    final effectiveSecret = secret.padRight(32, "=").substring(0, 32);

    final key = Key.fromUtf8(effectiveSecret);
    final iv = IV.fromUtf8(effectiveSecret.substring(0, 16));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(value, iv: iv);

    return encrypted.base64;
  }

  static String decrypt(String value, String secret) {
    final effectiveSecret = secret.padRight(32, "=").substring(0, 32);

    final key = Key.fromUtf8(effectiveSecret);
    final iv = IV.fromUtf8(effectiveSecret.substring(0, 16));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted.fromBase64(value);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
