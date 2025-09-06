import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ViewModelFactory {
  static AuthViewModel getAuthViewModel(BuildContext context) {
    return AuthViewModel(context.read<AuthRepository>());
  }
}
