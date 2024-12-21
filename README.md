# axons_totp  


**`axons_totp`** is a versatile Dart package that offers:  
- A simple and efficient implementation of the Time-Based One-Time Password (TOTP) algorithm.  
- Cryptography utilities for AES encryption and decryption.  
- `Hex` and `Base32` encoding/decoding utilities for secure data handling and interoperability.  

## Features  
- Generate and verify TOTPs compliant with [RFC 6238](https://datatracker.ietf.org/doc/html/rfc6238).  
- Encrypt and decrypt data using AES encryption.  
- Encode and decode data in `Hex` and `Base32` formats.  
- Generate random secure Base32-encoded strings for secret keys.  
- Pure Dart implementation with minimal dependencies.  

## Installation  

Add the package to your `pubspec.yaml` file:  
```yaml  
dependencies:  
  axons_totp: ^1.0.0  
```  

Then, run:  
```bash  
flutter pub get  
```  

## Usage  

### TOTP Functionality  

#### Generating a TOTP  
```dart  
import 'package:axons_totp/axons_totp.dart';  

void main() {  
  const secret = 'JBSWY3DPEHPK3PXP'; // Base32-encoded secret key  

  final otp = TOTP.generate(secret);  
  print('Generated OTP: $otp');  
}  
```  

#### Verifying a TOTP  
```dart  
import 'package:axons_totp/axons_totp.dart';  

void main() {  
  const secret = 'JBSWY3DPEHPK3PXP';  
  const code = '123456';  

  final isValid = TOTP.verify(code, secret);  
  print(isValid ? 'Valid OTP' : 'Invalid OTP');  
}  
```  

### Cryptography Utilities  

#### Encrypting a String  
```dart  
import 'package:axons_totp/axons_totp.dart';  

void main() {  
  const value = 'SensitiveData';  
  const secret = 'MyEncryptionKey';  

  final encrypted = Cryptography.encrypt(value, secret);  
  print('Encrypted: $encrypted');  
}  
```  

#### Decrypting a String  
```dart  
import 'package:axons_totp/axons_totp.dart';  

void main() {  
  const encryptedValue = '...';  // Replace with an actual encrypted base64 string  
  const secret = 'MyEncryptionKey';  

  final decrypted = Cryptography.decrypt(encryptedValue, secret);  
  print('Decrypted: $decrypted');  
}  
```  

### Encoding and Decoding Utilities  

#### Hex Encoding and Decoding  
```dart  
import 'package:axons_totp/axons_totp.dart';  
import 'dart:typed_data';  

void main() {  
  final hexString = '48656c6c6f'; // "Hello" in hex  
  final bytes = Hex.decode(hexString);  
  print('Decoded bytes: $bytes');  

  final encodedHex = Hex.encode(bytes);  
  print('Encoded hex: $encodedHex');  
}  
```  

#### Base32 Encoding and Decoding  
```dart  
import 'package:axons_totp/axons_totp.dart';  
import 'dart:typed_data';  

void main() {  
  final base32String = 'JBSWY3DPEHPK3PXP';  
  final bytes = Base32.decode(base32String);  
  print('Decoded bytes: $bytes');  

  final encodedBase32 = Base32.encode(Uint8List.fromList([72, 101, 108, 108, 111]));  
  print('Encoded Base32: $encodedBase32');  
}  
```  

#### Generating a Random Base32 String  
```dart  
import 'package:axons_totp/axons_totp.dart';  

void main() {  
  final randomString = Base32.random(length: 16);  
  print('Random Base32 String: $randomString');  
}  
```  

### API Reference  

#### `TOTP` Class  
- **`generate`**: Generates a TOTP based on the provided parameters.  
- **`verify`**: Verifies a TOTP with a specified tolerance for clock drift.  

#### `Cryptography` Class  
- **`encrypt`**: Encrypts a string using AES encryption.  
- **`decrypt`**: Decrypts a base64-encoded encrypted string.  

#### `Hex` Class  
- **`decode`**: Converts a hex string into a `Uint8List`.  
- **`encode`**: Converts a `Uint8List` into a hex string.  

#### `Base32` Class  
- **`encode`**: Converts a `Uint8List` into a Base32 string.  
- **`decode`**: Converts a Base32 string into a `Uint8List`.  
- **`toHex`**: Converts a Base32 string into a hex string.  
- **`fromHex`**: Converts a hex string into a Base32 string.  
- **`random`**: Generates a random Base32-encoded string.  

## Testing  

Run the tests to ensure all functionality works as expected:  
```bash  
dart test  
```  

## Contributing  
Contributions are welcome! If you’d like to contribute, please:  
1. Fork the repository.  
2. Create a new branch for your feature or bugfix.  
3. Submit a pull request.  

## License  
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.  
