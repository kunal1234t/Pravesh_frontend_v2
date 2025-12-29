import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;

/// ⚠️ NOTE:
/// This is for payload obfuscation / defense-in-depth.
/// DO NOT rely on this as primary security.
class CryptoUtils {
  /// 🔐 Key should come from secure source (env / backend / runtime)
  static encrypt.Key deriveKey(String secret) {
    // Ensure 32 bytes for AES-256
    return encrypt.Key.fromUtf8(secret.padRight(32).substring(0, 32));
  }

  /// 🔄 Generate random IV per encryption (CRITICAL)
  static encrypt.IV _generateRandomIV() {
    final rnd = Random.secure();
    return encrypt.IV(
      Uint8List.fromList(
        List<int>.generate(16, (_) => rnd.nextInt(256)),
      ),
    );
  }

  /// Encrypt JSON-safe payload
  /// Returns: base64(iv + ciphertext)
  static String encryptData({
    required Map<String, dynamic> data,
    required String secret,
  }) {
    try {
      final key = deriveKey(secret);
      final iv = _generateRandomIV();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(
          key,
          mode: encrypt.AESMode.cbc,
        ),
      );

      final jsonString = jsonEncode(data);
      final encrypted = encrypter.encrypt(jsonString, iv: iv);

      // Prepend IV to ciphertext
      final combined = iv.bytes + encrypted.bytes;
      return base64Encode(combined);
    } catch (e) {
      throw Exception('Encryption failed');
    }
  }
}
