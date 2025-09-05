import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/mixin/loading_mixin.dart';
import 'package:futurefinder_flutter/service/user_service.dart';

class HomeViewModel extends ChangeNotifier with LoadingMixin {
  final UserService _userService;

  HomeViewModel(this._userService);
}
