// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Yuva Bharata Sena';

  @override
  String get reportProblem => 'Report Problem';

  @override
  String get myLeaders => 'My Leaders';

  @override
  String get joinMovement => 'Join Movement';

  @override
  String get watchUpdates => 'Watch Updates';

  @override
  String get enterPhone => 'Enter your mobile number';

  @override
  String get phoneHint => '10-digit mobile number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String otpSentTo(String phone) {
    return 'OTP sent to +91 $phone';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get didntReceiveOtp => 'Didn\'\'t receive OTP?';

  @override
  String get profileSetup => 'Complete Your Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get selectDistrict => 'Select District';

  @override
  String get selectTaluk => 'Select Taluk';

  @override
  String get selectWard => 'Select Ward';

  @override
  String get referralCode => 'Referral Code (optional)';

  @override
  String get language => 'Language';

  @override
  String get submit => 'Submit';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get issueType => 'Select Issue Type';

  @override
  String get issueBribe => 'Bribe';

  @override
  String get issueRoad => 'Road';

  @override
  String get issueWater => 'Water';

  @override
  String get issueHospital => 'Hospital';

  @override
  String get issueSchool => 'School';

  @override
  String get issueElectricity => 'Electricity';

  @override
  String get issueFarmer => 'Farmer Issue';

  @override
  String get issueOther => 'Other';

  @override
  String get uploadMedia => 'Upload Photo / Video';

  @override
  String get addVoiceNote => 'Add Voice Note';

  @override
  String get addDescription => 'Describe the issue';

  @override
  String get issueSubmitted => 'Issue submitted successfully!';

  @override
  String get yourReferralCode => 'Your Referral Code';

  @override
  String get shareCode => 'Share Your Code';

  @override
  String get invite => 'Invite Friends';

  @override
  String get totalReferrals => 'Total Referrals';

  @override
  String get activityScore => 'Activity Score';

  @override
  String get yourRank => 'Your Rank';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get badges => 'Badges';

  @override
  String get events => 'Events';

  @override
  String get profile => 'Profile';

  @override
  String get signOut => 'Sign Out';

  @override
  String get volunteer => 'Volunteer';

  @override
  String get boothLead => 'Booth Lead';

  @override
  String get wardLead => 'Ward Lead';

  @override
  String get talukLead => 'Taluk Lead';

  @override
  String get districtLead => 'District Lead';

  @override
  String get stateLeader => 'State Leader';

  @override
  String get candidate => 'Candidate';

  @override
  String get issuesSolved => 'Issues Solved';

  @override
  String get membersRecruited => 'Members Recruited';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Something went wrong';
}
