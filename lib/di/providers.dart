import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders(String apiBaseUrl) => [
  Provider(create: (_) => ApiClient(apiBaseUrl)),
  Provider(create: (_) => SecureStorageDataSource()),
  Provider(
    create: (context) => UserRepository(
      context.read<ApiClient>(),
      context.read<SecureStorageDataSource>(),
    ),
  ),
];
