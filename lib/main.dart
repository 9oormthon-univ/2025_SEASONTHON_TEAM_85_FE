import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/router/router.dart';
//import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFFFFFF)),
      title: 'FutureFinder',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
