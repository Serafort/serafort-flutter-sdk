import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PKCEPair {
  final String codeVerifier;
  final String codeChallenge;
  final String codeChallengeMethod;

  const PKCEPair({
    required this.codeVerifier,
    required this.codeChallenge,
    this.codeChallengeMethod = 'S256',
  });

  static PKCEPair generate() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final verifier = _base64UrlEncode(values);

    final bytes = ascii.encode(verifier);
    final digest = sha256.convert(bytes);
    final challenge = _base64UrlEncode(digest.bytes);

    return PKCEPair(
      codeVerifier: verifier,
      codeChallenge: challenge,
    );
  }

  static String _base64UrlEncode(List<int> bytes) {
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
