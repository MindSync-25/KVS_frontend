abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class OtpFailure extends Failure {
  const OtpFailure([super.message = 'Invalid or expired OTP']);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([super.message = 'Too many attempts. Try again later.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error']);
}
