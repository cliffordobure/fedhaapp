class PasswordResetRequest {
  String email;
  String password;

  PasswordResetRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
