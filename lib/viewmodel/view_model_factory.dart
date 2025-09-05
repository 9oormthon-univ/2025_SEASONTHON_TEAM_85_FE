import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/service/user_service.dart';
import 'package:futurefinder_flutter/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class ViewModelFactory {
  static HomeViewModel getHomeViewModel(BuildContext context) {
    return HomeViewModel(context.read<UserService>());
  }
}
