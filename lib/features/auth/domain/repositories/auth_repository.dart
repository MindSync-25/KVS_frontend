import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phone);
  Future<AppUser> verifyOtpAndLogin({
    required String phone,
    required String otp,
  });
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
  });
  Future<AppUser?> getStoredUser();
  Future<void> signOut();
  Stream<AppUser?> watchCurrentUser();
}
