import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kn'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Karnataka Vijaya Sena'**
  String get appName;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report Problem'**
  String get reportProblem;

  /// No description provided for @myLeaders.
  ///
  /// In en, this message translates to:
  /// **'My Leaders'**
  String get myLeaders;

  /// No description provided for @joinMovement.
  ///
  /// In en, this message translates to:
  /// **'Join Movement'**
  String get joinMovement;

  /// No description provided for @watchUpdates.
  ///
  /// In en, this message translates to:
  /// **'Watch Updates'**
  String get watchUpdates;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterPhone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get phoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to +91 {phone}'**
  String otpSentTo(String phone);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @didntReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'\'t receive OTP?'**
  String get didntReceiveOtp;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get profileSetup;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select District'**
  String get selectDistrict;

  /// No description provided for @selectTaluk.
  ///
  /// In en, this message translates to:
  /// **'Select Taluk'**
  String get selectTaluk;

  /// No description provided for @selectWard.
  ///
  /// In en, this message translates to:
  /// **'Select Ward'**
  String get selectWard;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code (optional)'**
  String get referralCode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @issueType.
  ///
  /// In en, this message translates to:
  /// **'Select Issue Type'**
  String get issueType;

  /// No description provided for @issueBribe.
  ///
  /// In en, this message translates to:
  /// **'Bribe'**
  String get issueBribe;

  /// No description provided for @issueRoad.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get issueRoad;

  /// No description provided for @issueWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get issueWater;

  /// No description provided for @issueHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get issueHospital;

  /// No description provided for @issueSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get issueSchool;

  /// No description provided for @issueElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get issueElectricity;

  /// No description provided for @issueFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer Issue'**
  String get issueFarmer;

  /// No description provided for @issueOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get issueOther;

  /// No description provided for @uploadMedia.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo / Video'**
  String get uploadMedia;

  /// No description provided for @addVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Add Voice Note'**
  String get addVoiceNote;

  /// No description provided for @addDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get addDescription;

  /// No description provided for @issueSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Issue submitted successfully!'**
  String get issueSubmitted;

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get yourReferralCode;

  /// No description provided for @shareCode.
  ///
  /// In en, this message translates to:
  /// **'Share Your Code'**
  String get shareCode;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get invite;

  /// No description provided for @totalReferrals.
  ///
  /// In en, this message translates to:
  /// **'Total Referrals'**
  String get totalReferrals;

  /// No description provided for @activityScore.
  ///
  /// In en, this message translates to:
  /// **'Activity Score'**
  String get activityScore;

  /// No description provided for @yourRank.
  ///
  /// In en, this message translates to:
  /// **'Your Rank'**
  String get yourRank;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @volunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get volunteer;

  /// No description provided for @boothLead.
  ///
  /// In en, this message translates to:
  /// **'Booth Lead'**
  String get boothLead;

  /// No description provided for @wardLead.
  ///
  /// In en, this message translates to:
  /// **'Ward Lead'**
  String get wardLead;

  /// No description provided for @talukLead.
  ///
  /// In en, this message translates to:
  /// **'Taluk Lead'**
  String get talukLead;

  /// No description provided for @districtLead.
  ///
  /// In en, this message translates to:
  /// **'District Lead'**
  String get districtLead;

  /// No description provided for @stateLeader.
  ///
  /// In en, this message translates to:
  /// **'State Leader'**
  String get stateLeader;

  /// No description provided for @candidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get candidate;

  /// No description provided for @issuesSolved.
  ///
  /// In en, this message translates to:
  /// **'Issues Solved'**
  String get issuesSolved;

  /// No description provided for @membersRecruited.
  ///
  /// In en, this message translates to:
  /// **'Members Recruited'**
  String get membersRecruited;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kn':
      return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
