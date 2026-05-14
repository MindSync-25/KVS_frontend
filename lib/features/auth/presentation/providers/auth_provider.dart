import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/otp_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────
final otpServiceProvider = Provider<OtpService>((ref) => OtpService());

final authDatasourceProvider =
    Provider<AuthDatasource>((ref) => AuthDatasource());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    datasource: ref.read(authDatasourceProvider),
    otpService: ref.read(otpServiceProvider),
  );
});

/// Tracks whether the user chose "Party Member" during onboarding.
/// false = Citizen (public), true = Party Member
final pendingMemberProvider = StateProvider<bool>((ref) => false);

// ── Auth state ─────────────────────────────────────────────────────────────────
enum AuthStatus { loading, unauthenticated, newUser, authenticated }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? pendingPhone; // phone after OTP sent, before profile created
  final String? pendingUid;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.pendingPhone,
    this.pendingUid,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? pendingPhone,
    String? pendingUid,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      pendingPhone: pendingPhone ?? this.pendingPhone,
      pendingUid: pendingUid ?? this.pendingUid,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return const AuthState(status: AuthStatus.loading);
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _init() async {
    try {
      final user = await _repo.getStoredUser();
      if (user == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      }
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      await _repo.sendOtp(phone);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        pendingPhone: phone,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> verifyOtp(String otp) async {
    final phone = state.pendingPhone;
    if (phone == null) return;
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repo.verifyOtpAndLogin(phone: phone, otp: otp);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('NEW_USER')) {
        // Retrieve UID from Supabase session after sign-in
        final uid = ref.read(authDatasourceProvider).currentAuthUser?.id ?? '';
        state = AuthState(
          status: AuthStatus.newUser,
          pendingPhone: phone,
          pendingUid: uid,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: msg,
        );
      }
    }
  }

  Future<void> createProfile({
    required String name,
    required String district,
    required String taluk,
    required String ward,
    required String constituencyId,
    required String language,
    String? referredBy,
  }) async {
    final phone = state.pendingPhone;
    final uid   = state.pendingUid;
    if (phone == null || uid == null) return;

    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repo.createProfile(
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
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.newUser,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// UI-testing only — loads a mock user bypassing Supabase entirely.
  void enterDemoMode() {
    const demoLanguage = 'kn';
    ref.read(localeProvider.notifier).state = const Locale(demoLanguage);
    state = AuthState(
      status: AuthStatus.authenticated,
      user: AppUser(
        uid: 'demo-uid-001',
        phone: '9999999999',
        name: 'Demo User',
        role: UserRole.member,
        position: PartyPosition.member,
        positionStatus: PositionStatus.active,
        district: 'Bengaluru Urban',
        taluk: 'Bengaluru North',
        ward: 'Hebbal Ward',
        constituencyId: 'constituency-001',
        referralCode: 'DEMO001',
        referralCount: 7,
        activityScore: 42,
        issuesReported: 8,
        issuesResolved: 3,
        eventsAttended: 2,
        badges: ['Early Adopter', 'Issue Reporter'],
        isVerified: true,
        isActive: true,
        language: 'kn',
        createdAt: DateTime(2025, 1, 1),
        lastActiveAt: DateTime.now(),
      ),
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Convenience: current logged-in user or null
final currentUserProvider = Provider<AppUser?>(
  (ref) => ref.watch(authProvider).user,
);
