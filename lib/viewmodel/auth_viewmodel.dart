import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  Future<int> login({
    required String accountId,
    required String password,
    required String deviceId,
    required String provider,
  }) async {
    LoginRequest request = LoginRequest(
      accountId: accountId,
      password: password,
      deviceId: deviceId,
      provider: provider,
      appToken: "push-token-abcdef",
    );

    return await _authRepository.login(request);
  }
}
