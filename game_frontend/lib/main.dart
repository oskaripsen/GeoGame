import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/intermediary_page.dart';
import 'screens/game_page.dart';
import 'screens/home_screen.dart';  // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/intermediary': (context) => const IntermediaryPage(),
        '/game': (context) => const GamePage(),
        '/energy_game': (context) => HomeScreen(),  // Add this route
      },
    );
  }
}
