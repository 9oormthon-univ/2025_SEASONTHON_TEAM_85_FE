import 'package:flutter/material.dart';
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
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.white,
          colorScheme: const ColorScheme.light(
            surface: Colors.white,
            primary: Color(0xFF00BFFF),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        ),
        title: 'FutureFinder',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
