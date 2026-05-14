import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand palette — Deep Navy + Saffron (KVS movement)
  static const Color primary       = Color(0xFF0F2167);   // deep royal navy
  static const Color primaryDark   = Color(0xFF091444);   // darker navy
  static const Color primaryLight  = Color(0xFF1B3A8C);   // medium navy
  static const Color accent        = Color(0xFFFF6D00);   // vibrant saffron
  static const Color accentLight   = Color(0xFFFF9240);   // light saffron
  static const Color gold          = Color(0xFFFFB800);   // gold for ranks/badges

  // Legacy aliases so other files compile without change
  static const Color secondary     = Color(0xFF1B3A8C);
  static const Color secondaryDark = Color(0xFF0F2167);

  // Backgrounds
  static const Color background    = Color(0xFFF4F6FF);   // light navy tint
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceVariant= Color(0xFFEEF2FF);

  // Text
  static const Color textPrimary   = Color(0xFF0A0F2E);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textHint      = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent  = Color(0xFFFFFFFF);

  // Status colours
  static const Color success       = Color(0xFF28A745);
  static const Color warning       = Color(0xFFFFC107);
  static const Color error         = Color(0xFFDC3545);
  static const Color info          = Color(0xFF17A2B8);

  // Issue-type tag colours
  static const Color issueBribe       = Color(0xFFDC3545);
  static const Color issueRoad        = Color(0xFFFF8C00);
  static const Color issueWater       = Color(0xFF17A2B8);
  static const Color issueHospital    = Color(0xFFE83E8C);
  static const Color issueSchool      = Color(0xFF6F42C1);
  static const Color issueElectricity = Color(0xFFFFC107);
  static const Color issueFarmer      = Color(0xFF28A745);
  static const Color issueOther       = Color(0xFF6C757D);

  // Rank badge colours
  static const Color rankVolunteer  = Color(0xFFCD7F32);
  static const Color rankBoothLead  = Color(0xFFC0C0C0);
  static const Color rankWardLead   = Color(0xFFFFD700);
  static const Color rankTalukLead  = Color(0xFF00BFFF);
  static const Color rankDistLead   = Color(0xFF9B59B6);
  static const Color rankState      = Color(0xFFFFD700);
  static const Color rankCandidate  = Color(0xFFFF6D00);

  // Dark mode
  static const Color backgroundDark = Color(0xFF0A0F2E);
  static const Color surfaceDark    = Color(0xFF0F1A4A);
}
