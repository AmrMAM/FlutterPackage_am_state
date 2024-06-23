import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

abstract class AmTools {
  /// to generate unique id in milli seconds resolution
  static String genUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// to generate unique id in micro seconds resolution
  static String genUniqueIdMicro() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Calculates the MD5 hash of the given String
  static String calculateMD5Hash(String inputString) {
    var bytes = utf8.encode(inputString);
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  /// Calculates the MD5 hash of the given File
  static Future<String> calculateMD5HashFromFile(File file) async {
    var bytes = await file.readAsBytes();
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  /// Calculates the MD5 hash of the given bytes [Uint8List]
  static Future<String> calculateMD5HashFromBytes(Uint8List bytes) async {
    var digest = md5.convert(bytes);

    return digest.toString();
  }
}
