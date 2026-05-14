import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_strings.dart';
import 'features/auth/domain/entities/app_user.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/auth/presentation/pages/phone_auth_page.dart';
import 'features/auth/presentation/pages/otp_verify_page.dart';
import 'features/auth/presentation/pages/profile_setup_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/issues/presentation/pages/report_issue_page.dart';
import 'features/issues/presentation/pages/issues_list_page.dart';
import 'features/issues/presentation/pages/issue_detail_page.dart';
import 'features/leaders/presentation/pages/leaders_list_page.dart';
import 'features/leaders/presentation/pages/leader_profile_page.dart';
import 'features/feed/presentation/pages/feed_page.dart';
import 'features/recruitment/presentation/pages/join_movement_page.dart';
import 'features/recruitment/presentation/pages/referral_dashboard_page.dart';
import 'features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/events/presentation/pages/events_page.dart';
import 'features/admin/presentation/pages/admin_dashboard_page.dart';

/// Bridges Riverpod auth state changes into a [ChangeNotifier] so GoRouter
/// can refresh its redirect without being recreated.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppStrings.routeSplash,
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      // Always read fresh state — never captured in closure
      final authState = ref.read(authProvider);
      final status = authState.status;
      final path = state.uri.path;

      // While loading — stay on splash
      if (status == AuthStatus.loading) {
        return path == AppStrings.routeSplash ? null : AppStrings.routeSplash;
      }

      // Unauthenticated — redirect splash to onboarding, allow auth routes
      if (status == AuthStatus.unauthenticated) {
        if (path == AppStrings.routeSplash) return AppStrings.routeOnboarding;
        final allowed = [
          AppStrings.routeOnboarding,
          AppStrings.routePhone,
          AppStrings.routeOtp,
        ];
        if (!allowed.contains(path)) return AppStrings.routeOnboarding;
        return null;
      }

      // New user — must complete profile
      if (status == AuthStatus.newUser) {
        if (path != AppStrings.routeProfileSetup) {
          return AppStrings.routeProfileSetup;
        }
        return null;
      }

      // Authenticated — block auth routes
      if (status == AuthStatus.authenticated) {
        final authRoutes = [
          AppStrings.routeSplash,
          AppStrings.routeOnboarding,
          AppStrings.routePhone,
          AppStrings.routeOtp,
          AppStrings.routeProfileSetup,
        ];
        if (authRoutes.contains(path)) return AppStrings.routeHome;

        // Admin-only guard
        if (path.startsWith('/admin')) {
          final user = authState.user;
          if (user?.role != UserRole.admin) return AppStrings.routeHome;
        }
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppStrings.routeSplash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppStrings.routeOnboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppStrings.routePhone,
        builder: (_, __) => const PhoneAuthPage(),
      ),
      GoRoute(
        path: AppStrings.routeOtp,
        builder: (_, __) => const OtpVerifyPage(),
      ),
      GoRoute(
        path: AppStrings.routeProfileSetup,
        builder: (_, __) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: AppStrings.routeHome,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: AppStrings.routeReportIssue,
        builder: (_, __) => const ReportIssuePage(),
      ),
      GoRoute(
        path: AppStrings.routeIssuesList,
        builder: (_, __) => const IssuesListPage(),
      ),
      GoRoute(
        path: AppStrings.routeIssueDetail,
        builder: (context, state) => IssueDetailPage(
          issueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppStrings.routeLeaders,
        builder: (_, __) => const LeadersListPage(),
      ),
      GoRoute(
        path: AppStrings.routeLeaderDetail,
        builder: (context, state) => LeaderProfilePage(
          leaderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppStrings.routeFeed,
        builder: (_, __) => const FeedPage(),
      ),
      GoRoute(
        path: AppStrings.routeJoin,
        builder: (_, __) => const JoinMovementPage(),
      ),
      GoRoute(
        path: AppStrings.routeReferral,
        builder: (_, __) => const ReferralDashboardPage(),
      ),
      GoRoute(
        path: AppStrings.routeLeaderboard,
        builder: (_, __) => const LeaderboardPage(),
      ),
      GoRoute(
        path: AppStrings.routeProfile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: AppStrings.routeEvents,
        builder: (_, __) => const EventsPage(),
      ),
      GoRoute(
        path: AppStrings.routeAdmin,
        builder: (_, __) => const AdminDashboardPage(),
      ),
    ],
  );
});
