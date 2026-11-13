part of 'bloc.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountStarted extends AccountEvent {}

class ResetAccount extends AccountEvent {}

class GoogleSigneOut extends AccountEvent {}

class RefreshProfile extends AccountEvent {}

class DeleteAccount extends AccountEvent {
  final DeleteAccountRequest password;
  DeleteAccount({required this.password});

  @override
  List<Object?> get props => [password];
}

class AccountUpdated extends AccountEvent {
  final ProfileUpdateData data;

  AccountUpdated(this.data);
  @override
  List<Object?> get props => [data];
}

class LoginEvent extends AccountEvent {
  final LoginRequest data;

  LoginEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class RegisterEvent extends AccountEvent {
  final RegisterRequest data;

  RegisterEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class RequestOtp extends AccountEvent {
  final String phone;

  RequestOtp({required this.phone});
  @override
  List<Object?> get props => [phone];
}

/// Restore in-memory user so OTP screen can verify/resend after leaving.
class RestorePendingOtpUser extends AccountEvent {
  final String email;
  final String phone;
  final String? name;

  RestorePendingOtpUser({
    required this.email,
    required this.phone,
    this.name,
  });

  @override
  List<Object?> get props => [email, phone, name];
}

class VerifyEmailOtp extends AccountEvent {
  final EmailOtpRequest request;
  VerifyEmailOtp({required this.request});
  @override
  List<Object?> get props => [request];
}

/// Password-reset OTP verification (uses password/verify/otp).
class ResetVerifyEmailOtp extends AccountEvent {
  final EmailOtpRequest request;
  ResetVerifyEmailOtp({required this.request});
  @override
  List<Object?> get props => [request];
}

class VerifyOtp extends AccountEvent {
  final OtpVerifyRequest request;
  VerifyOtp({required this.request});
  @override
  List<Object?> get props => [request];
}

class ChangePasswordEvent extends AccountEvent {
  final Changepassword request;
  ChangePasswordEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class PasswordResetEvent extends AccountEvent {
  final PasswordResetRequest request;
  PasswordResetEvent({required this.request});
  @override
  List<Object?> get props => [request];
}

class ResetPassword extends AccountEvent {
  // TODO! implement password reset
}

class ForgotPasswordEvent extends AccountEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class GoogleAuthentication extends AccountEvent {}
