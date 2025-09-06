class LoginRequest {
  final String accountId;
  final String password;
  final String deviceId;
  final String provider;
  final String appToken;

  LoginRequest({
    required this.accountId,
    required this.password,
    required this.deviceId,
    required this.provider,
    required this.appToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'password': password,
      'deviceId': deviceId,
      'provider': provider,
      'appToken': appToken,
    };
  }

  @override
  String toString() {
    return 'LoginRequest(accountId: $accountId, password: $password, deviceId: $deviceId, provider: $provider, appToken: $appToken)';
  }
}

class LoginResponse {
  final int status;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as int,
      accessToken: json['data']['accessToken'],
      refreshToken: json['data']['refreshToken'],
    );
  }
}

class SignUpRequest {
  final String accountId;
  final String userName;
  final String nickName;
  final String deviceId;
  final String provider;
  final String appToken;

  SignUpRequest({
    required this.accountId,
    required this.userName,
    required this.nickName,
    required this.deviceId,
    required this.provider,
    required this.appToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'userName': userName,
      'nickName': nickName,
      'deviceId': deviceId,
      'provider': provider,
      'appToken': appToken,
    };
  }
}

class SignUpResponse {
  final int status;
  final String message;

  SignUpResponse({required this.status, required this.message});
}
class CreatePasswordRequest {
  final String password;
  CreatePasswordRequest({required this.password});

  Map<String, dynamic> toJson() => {
    "password": password,
  };
}