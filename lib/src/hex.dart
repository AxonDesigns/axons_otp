import 'dart:typed_data';

class Hex {
  static Uint8List decode(String hex) {
    if (hex.length % 2 != 0) {
      throw 'Odd number of hex digits';
    }

    var l = hex.length ~/ 2;
    var result = Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result[i] = x;
    }
    return result;
  }

  static String encode(Uint8List bytes, {bool upperCase = false}) {
    StringBuffer buffer = StringBuffer();
    for (int part in bytes) {
      if (part & 0xff != part) {
        throw FormatException("Non-byte integer");
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    if (upperCase) {
      return buffer.toString().toUpperCase();
    } else {
      return buffer.toString();
    }
  }
}
