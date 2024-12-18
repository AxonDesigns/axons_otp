import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';

class Base32 {
  /// Takes in a [byteList] converts it to a Uint8List so that I
  /// can run bit operations on it, then outputs a [String]
  /// representation of the base32.
  static String encode(Uint8List bytes) {
    return base32.encode(bytes);
  }

  /// Takes in a base32 string and decodes it back to a [Uint8List]
  /// that can be converted to a hex string using [toHex].
  static Uint8List decode(String value) {
    return base32.decode(value);
  }

  /// Takes in a base32 string and decodes it back to a [String] in hex format.
  static String toHex(String value) {
    return base32.decodeAsHexString(value);
  }

  /// Takes in a hex string, converts the string to a byte
  /// list and runs a normal encode() on it. Returning a [String]
  /// representation of the base32.
  static String fromHex(String value) {
    return base32.encodeHexString(value);
  }

  /// Generates a random string encoded in Base32 with the specified length.<br>
  ///
  /// This method creates a secure random string suitable for use as a secret key
  /// for TOTP or other cryptographic purposes. The output is encoded in Base32.<br>
  ///
  /// [length] - The desired length of the generated string (default is 32).<br>
  ///
  /// Returns a Base32-encoded random string truncated to the specified length.<br>
  static String random({int length = 32}) {
    // Base32 encoding uses 5 bits per character
    int requiredBytes = (length * 5 / 8).ceil();
    final Random random = Random.secure();
    final List<int> randomBytes = List<int>.generate(
      requiredBytes,
      (_) => random.nextInt(256),
    );

    final encoded = base32.encode(Uint8List.fromList(randomBytes));

    return encoded.substring(0, length);
  }
}

/*class Base32 {
  static Uint8List decode(String input) {
    const String base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    List<int> bytes = [];
    int bits = 0;
    int value = 0;

    for (int i = 0; i < input.length; i++) {
      int val = base32chars.indexOf(input[i].toUpperCase());
      if (val == -1) continue;
      value = (value << 5) | val;
      bits += 5;

      if (bits >= 8) {
        bytes.add((value >> (bits - 8)) & 0xff);
        bits -= 8;
      }
    }
    return Uint8List.fromList(bytes);
  }

  static String encode(Uint8List bytes) {
    const String base32Charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; // Base32 alphabet
    StringBuffer result = StringBuffer();

    int buffer = 0;
    int bufferLength = 0;

    for (int byte in bytes) {
      buffer = (buffer << 8) | byte;
      bufferLength += 8;

      while (bufferLength >= 5) {
        int index = (buffer >> (bufferLength - 5)) & 0x1F;
        result.write(base32Charset[index]);
        bufferLength -= 5;
      }
    }

    if (bufferLength > 0) {
      int index = (buffer << (5 - bufferLength)) & 0x1F;
      result.write(base32Charset[index]);
    }

    return result.toString();
  }

  static String toHex(String base32) {
    const String base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    String bits = "";
    String hex = "";

    // Convert Base32 characters to binary string
    for (int i = 0; i < base32.length; i++) {
      int val = base32chars.indexOf(base32[i].toUpperCase());
      if (val == -1) continue; // Skip invalid characters
      bits += val.toRadixString(2).padLeft(5, '0');
    }

    // Convert binary string to hexadecimal
    for (int i = 0; i + 4 <= bits.length; i += 4) {
      String chunk = bits.substring(i, i + 4);
      hex += int.parse(chunk, radix: 2).toRadixString(16);
    }

    return hex;
  }
}*/
