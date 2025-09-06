import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:futurefinder_flutter/di/providers.dart';
import 'package:futurefinder_flutter/router/router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders('http://15.164.172.236/api'),
      child: MaterialApp.router(
        builder: EasyLoading.init(),
        theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFFFFFF)),
        title: 'FutureFinder',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
