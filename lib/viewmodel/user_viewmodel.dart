import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/service/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;

  UserViewModel(this._userService);
}
