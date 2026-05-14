class Validators {
  Validators._();

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number required';
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10) return 'Enter a valid 10-digit number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid Indian mobile number';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP required';
    if (value.length != 6) return 'Enter 6-digit OTP';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return 'OTP must be numeric';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name required';
    if (value.trim().length < 2) return 'Name too short';
    if (value.trim().length > 80) return 'Name too long';
    return null;
  }

  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? referralCode(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    if (!RegExp(r'^[A-Z0-9]{6,10}$').hasMatch(value.toUpperCase())) {
      return 'Invalid referral code format';
    }
    return null;
  }
}
