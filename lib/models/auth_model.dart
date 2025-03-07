class AuthCredentials {
  final String email;
  final String password;

  AuthCredentials({
    required this.email,
    required this.password,
  });
}

class AuthResponse {
  final bool success;
  final String? token;
  final String? error;
  final String? userId;

  AuthResponse({
    required this.success,
    this.token,
    this.error,
    this.userId,
  });

  factory AuthResponse.success({required String token, required String userId}) {
    return AuthResponse(
      success: true,
      token: token,
      userId: userId,
    );
  }

  factory AuthResponse.error(String message) {
    return AuthResponse(
      success: false,
      error: message,
    );
  }
} 