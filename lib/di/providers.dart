import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';
import 'package:futurefinder_flutter/repository/job_repository.dart'; // 추가
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:futurefinder_flutter/viewmodel/job_viewmodel.dart'; // 추가
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders(String apiBaseUrl) => [
  Provider(create: (_) => ApiClient(apiBaseUrl)),
  Provider(create: (_) => SecureStorageDataSource()),
  Provider(
    create: (context) => AuthRepository(
      context.read<ApiClient>(),
      context.read<SecureStorageDataSource>(),
    ),
  ),
  // JobRepository 추가
  Provider(
    create: (context) => JobRepository(
      context.read<ApiClient>(),
      context.read<SecureStorageDataSource>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => AuthViewModel(context.read<AuthRepository>()),
  ),
  // JobViewModel 추가
  ChangeNotifierProvider(
    create: (context) => JobViewModel(context.read<JobRepository>()),
  ),
];
