import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/repository/asset_repository.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';
import 'package:futurefinder_flutter/repository/search_repository.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
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
  Provider(
    create: (context) => SearchRepository(
      context.read<ApiClient>(),
      context.read<SecureStorageDataSource>(),
    ),
  ),
  Provider(
    create: (context) => AssetRepository(
      context.read<ApiClient>(),
      context.read<SecureStorageDataSource>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => AuthViewModel(context.read<AuthRepository>()),
  ),
];
