import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';
import 'package:futurefinder_flutter/model/user.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthViewModel(this._authRepository);

  Future<void> refreshToken() async {
    await _authRepository.refreshAccessToken();
  }

  Future<void> fetchUserProfile() async {
    _currentUser = await _authRepository.getProfile();
    notifyListeners();
  }

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
