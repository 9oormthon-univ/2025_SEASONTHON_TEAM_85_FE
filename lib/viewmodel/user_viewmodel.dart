import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/user.dart';
import 'package:futurefinder_flutter/repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  User? _currentUser;
  User? get currentUser => _currentUser;

  UserViewModel(this._userRepository);

  Future<void> fetchUserProfile() async {
    _currentUser = await _userRepository.getProfile();
    notifyListeners();
  }
}
