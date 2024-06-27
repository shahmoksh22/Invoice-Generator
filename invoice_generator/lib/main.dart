import 'package:flutter/material.dart';
import 'package:invoice_generator/Screen/home_screen.dart';
import 'package:invoice_generator/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>const SplashScreen(),
        '/home': (context) =>const HomeScreen(),
      },
    );
  }
}
