import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/otp_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  final OtpService _otpService;

  AuthRepositoryImpl({
    required AuthDatasource datasource,
    required OtpService otpService,
  })  : _datasource = datasource,
        _otpService = otpService;

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await _otpService.sendOtp(phone);
    } on Failure {
      rethrow;
    } catch (e) {
      appLogger.e('sendOtp error: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AppUser> verifyOtpAndLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      // 1. Verify OTP with MSG91
      await _otpService.verifyOtp(phone, otp);

      // 2. Sign in to Supabase (creates session)
      await _datasource.signInWithPhone(phone);
      final authResp = await _datasource.verifyPhoneOtp(phone, otp);
      final uid = authResp.user?.id;
      if (uid == null) throw const AuthFailure('Sign in failed');

      // 3. Fetch user profile
      final profile = await _datasource.fetchUserProfile(uid);
      if (profile == null) {
        // New user — signal with null so UI goes to profile setup
        throw const AuthFailure('NEW_USER');
      }

      // 4. Issue device trust token
      await _otpService.generateDeviceToken(uid);
      await _datasource.touchLastActive(uid);

      return profile;
    } on Failure {
      rethrow;
    } catch (e) {
      appLogger.e('verifyOtpAndLogin error: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AppUser> createProfile({
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
    try {
      return await _datasource.createUserProfile(
        uid: uid,
        phone: phone,
        name: name,
        district: district,
        taluk: taluk,
        ward: ward,
        constituencyId: constituencyId,
        language: language,
        referredBy: referredBy,
      );
    } catch (e) {
      appLogger.e('createProfile error: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AppUser?> getStoredUser() async {
    try {
      final authUser = _datasource.currentAuthUser;
      if (authUser == null) return null;
      return _datasource.fetchUserProfile(authUser.id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _otpService.clearDeviceToken();
    await _datasource.signOut();
  }

  @override
  Stream<AppUser?> watchCurrentUser() {
    return Supabase.instance.client.auth.onAuthStateChange.asyncMap(
      (event) async {
        final uid = event.session?.user.id;
        if (uid == null) return null;
        return _datasource.fetchUserProfile(uid);
      },
    );
  }
}
