import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/constants/app_strings.dart';

class OtpService {
  final _storage = const FlutterSecureStorage();

  // ── Send OTP via MSG91 ────────────────────────────────────────────────────
  Future<void> sendOtp(String phone) async {
    final authKey = dotenv.env['MSG91_AUTH_KEY']!;
    final templateId = dotenv.env['MSG91_TEMPLATE_ID']!;
    final senderId = dotenv.env['MSG91_SENDER_ID'] ?? 'KVSSMS';

    // MSG91 Send OTP endpoint
    final uri = Uri.parse('https://control.msg91.com/api/v5/otp');
    final response = await http.post(
      uri,
      headers: {
        'authkey': authKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'template_id': templateId,
        'mobile': '91$phone',
        'otp_length': 6,
        'otp_expiry': 10,     // minutes
        'sender': senderId,
      }),
    );

    if (response.statusCode != 200) {
      appLogger.e('MSG91 send error: ${response.body}');
      throw const ServerFailure('Failed to send OTP. Please try again.');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['type'] != 'success') {
      appLogger.e('MSG91 send failed: $body');
      throw ServerFailure(body['message']?.toString() ?? 'OTP send failed');
    }
  }

  // ── Verify OTP via MSG91 ──────────────────────────────────────────────────
  Future<void> verifyOtp(String phone, String otp) async {
    final authKey = dotenv.env['MSG91_AUTH_KEY']!;

    final uri = Uri.parse(
      'https://control.msg91.com/api/v5/otp/verify?mobile=91$phone&otp=$otp',
    );
    final response = await http.get(
      uri,
      headers: {'authkey': authKey},
    );

    if (response.statusCode != 200) {
      throw const OtpFailure();
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['type'] != 'success') {
      throw const OtpFailure('Invalid or expired OTP');
    }
  }

  // ── Device trust token ────────────────────────────────────────────────────
  /// Generates a HMAC-signed device token and stores it securely.
  /// Returns the token string.
  Future<String> generateDeviceToken(String uid) async {
    final secret = dotenv.env['DEVICE_SECRET']!;
    final nonce = _randomHex(16);
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    final payload = '$uid:$nonce:$ts';

    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(utf8.encode(payload));
    final token = '$payload:${digest.toString()}';

    await _storage.write(key: AppStrings.keyDeviceToken, value: token);
    await _storage.write(key: AppStrings.keyDeviceTokenTs, value: ts);
    return token;
  }

  /// Returns stored token if valid and < 30 days old, else null.
  Future<String?> getValidDeviceToken(String uid) async {
    try {
      final token = await _storage.read(key: AppStrings.keyDeviceToken);
      final ts    = await _storage.read(key: AppStrings.keyDeviceTokenTs);
      if (token == null || ts == null) return null;

      final tokenUid = token.split(':').first;
      if (tokenUid != uid) return null;

      final tokenAge = DateTime.now().millisecondsSinceEpoch -
          int.parse(ts);
      const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
      if (tokenAge > thirtyDaysMs) {
        await _storage.delete(key: AppStrings.keyDeviceToken);
        return null;
      }
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearDeviceToken() async {
    await _storage.delete(key: AppStrings.keyDeviceToken);
    await _storage.delete(key: AppStrings.keyDeviceTokenTs);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _randomHex(int length) {
    final rng = Random.secure();
    final bytes = List<int>.generate(length, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
