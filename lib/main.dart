import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/home_screen.dart';
//import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureFinder',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => HomeScreen()},
    );
  }
}
