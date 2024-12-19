class Login {
  final String email;
  final String password;
  final String deviceId;

  Login({required this.email, required this.password, required this.deviceId});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      deviceId: json['deviceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
    };
  }
}
