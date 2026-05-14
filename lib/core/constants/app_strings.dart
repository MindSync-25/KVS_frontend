class AppStrings {
  AppStrings._();

  // Route paths
  static const String routeSplash       = '/';
  static const String routeOnboarding   = '/onboarding';
  static const String routePhone        = '/auth/phone';
  static const String routeOtp          = '/auth/otp';
  static const String routeProfileSetup = '/auth/profile-setup';
  static const String routeHome         = '/home';
  static const String routeReportIssue  = '/issues/report';
  static const String routeIssueDetail  = '/issues/:id';
  static const String routeIssuesList   = '/issues';
  static const String routeLeaders      = '/leaders';
  static const String routeLeaderDetail = '/leaders/:id';
  static const String routeFeed         = '/feed';
  static const String routeJoin         = '/join';
  static const String routeReferral     = '/referral';
  static const String routeLeaderboard  = '/leaderboard';
  static const String routeProfile      = '/profile';
  static const String routeEvents       = '/events';
  static const String routeAdmin        = '/admin';

  // Hive box names
  static const String boxUser           = 'user_box';
  static const String boxIssues         = 'issues_box';
  static const String boxSettings       = 'settings_box';

  // Secure storage keys
  static const String keyDeviceToken    = 'device_trust_token';
  static const String keyDeviceTokenTs  = 'device_trust_token_ts';

  // SharedPrefs keys
  static const String prefLanguage      = 'language';
  static const String prefOnboarded     = 'onboarded';
}

/// Convenient short-alias class for GoRouter navigation
class AppRoutes {
  AppRoutes._();

  static const String splash       = AppStrings.routeSplash;
  static const String onboarding   = AppStrings.routeOnboarding;
  static const String phone        = AppStrings.routePhone;
  static const String otp          = AppStrings.routeOtp;
  static const String profileSetup = AppStrings.routeProfileSetup;
  static const String home         = AppStrings.routeHome;
  static const String reportIssue  = AppStrings.routeReportIssue;
  static const String issueDetail  = AppStrings.routeIssueDetail;
  static const String issuesList   = AppStrings.routeIssuesList;
  static const String leaders      = AppStrings.routeLeaders;
  static const String leaderDetail = AppStrings.routeLeaderDetail;
  static const String feed         = AppStrings.routeFeed;
  static const String joinMovement = AppStrings.routeJoin;
  static const String referral     = AppStrings.routeReferral;
  static const String leaderboard  = AppStrings.routeLeaderboard;
  static const String profile      = AppStrings.routeProfile;
  static const String events       = AppStrings.routeEvents;
  static const String admin        = AppStrings.routeAdmin;
}
