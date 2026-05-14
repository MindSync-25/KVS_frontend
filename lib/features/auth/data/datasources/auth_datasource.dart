import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/supabase_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

class AuthDatasource {
  final _uuid = const Uuid();

  // ── Sign in with OTP-verified phone (custom flow) ─────────────────────────
  /// We use Supabase's phone OTP as a fallback sign-in only if needed.
  /// Primary flow: MSG91 OTP → verified → signInWithOtp here.
  Future<void> signInWithPhone(String phone) async {
    await supabase.auth.signInWithOtp(phone: '+91$phone');
  }

  Future<AuthResponse> verifyPhoneOtp(String phone, String otp) async {
    return supabase.auth.verifyOTP(
      phone: '+91$phone',
      token: otp,
      type: OtpType.sms,
    );
  }

  // ── Get current session ───────────────────────────────────────────────────
  Session? get currentSession => supabase.auth.currentSession;
  User? get currentAuthUser => supabase.auth.currentUser;

  // ── Fetch user profile ────────────────────────────────────────────────────
  Future<UserModel?> fetchUserProfile(String uid) async {
    final data = await supabase
        .from('users')
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (data == null) return null;
    return UserModel.fromMap(data);
  }

  // ── Create new user profile ───────────────────────────────────────────────
  Future<UserModel> createUserProfile({
    required String uid,
    required String phone,
    required String name,
    required String district,
    required String taluk,
    required String ward,
    required String constituencyId,
    required String language,
    String? referredBy,
  }) async {
    final referralCode = _generateReferralCode(name);
    final now = DateTime.now().toIso8601String();

    final payload = {
      'uid': uid,
      'phone': phone,
      'name': name,
      'photo_url': null,
      'role': 'public',
      'rank': 'volunteer',
      'district': district,
      'taluk': taluk,
      'ward': ward,
      'constituency_id': constituencyId,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'referral_count': 0,
      'activity_score': 0,
      'issues_reported': 0,
      'issues_resolved': 0,
      'events_attended': 0,
      'badges': <String>[],
      'is_verified': false,
      'is_active': true,
      'language': language,
      'created_at': now,
      'last_active_at': now,
    };

    final data = await supabase
        .from('users')
        .insert(payload)
        .select()
        .single();

    // Record referral chain if code was used
    if (referredBy != null) {
      await _recordReferral(referredBy, uid, name);
    }

    return UserModel.fromMap(data);
  }

  // ── Update last active ────────────────────────────────────────────────────
  Future<void> touchLastActive(String uid) async {
    await supabase
        .from('users')
        .update({'last_active_at': DateTime.now().toIso8601String()})
        .eq('uid', uid);
  }

  // ── Sign out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // ── Private helpers ───────────────────────────────────────────────────────
  String _generateReferralCode(String name) {
    final prefix = name
        .replaceAll(RegExp(r'[^A-Za-z]'), '')
        .toUpperCase()
        .substring(0, name.length >= 3 ? 3 : name.length)
        .padRight(3, 'K');
    final suffix = _uuid.v4().replaceAll('-', '').substring(0, 5).toUpperCase();
    return '$prefix$suffix';
  }

  Future<void> _recordReferral(
    String referrerId,
    String refereeId,
    String refereeName,
  ) async {
    try {
      await supabase.from('referrals').insert({
        'referrer_id': referrerId,
        'referee_id': refereeId,
        'referee_name': refereeName,
        'verified': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      appLogger.w('Referral record failed (non-critical): $e');
    }
  }
}
