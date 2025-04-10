class AuthCredentials {
  final String email;
  final String password;
  final String? name;
  final String? address;
  final String? birthDate;
  final bool? isStore;

  AuthCredentials.login({required this.email, required this.password})
    : name = '',
      address = '',
      birthDate = '',
      isStore = false;

  AuthCredentials.register({
    required this.email,
    required this.password,
    required this.name,
    required this.address,
    required this.birthDate,
    required this.isStore,
  });
}

class AuthResponse {
  final bool success;
  final String? token;
  final String? error;
  final String? userId;

  AuthResponse({required this.success, this.token, this.error, this.userId});

  factory AuthResponse.success({
    required String token,
    required String userId,
  }) {
    return AuthResponse(success: true, token: token, userId: userId);
  }

  factory AuthResponse.error(String message) {
    return AuthResponse(success: false, error: message);
  }
}
