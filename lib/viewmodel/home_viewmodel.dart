import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/mixin/loading_mixin.dart';
import 'package:futurefinder_flutter/repository/user_repository.dart';

class HomeViewModel extends ChangeNotifier with LoadingMixin {
  final UserRepository _userRepository;

  HomeViewModel(this._userRepository);
}
