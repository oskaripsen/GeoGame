import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/intermediary_page.dart';
import 'screens/game_page.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';  // Import our new theme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Game',
      theme: AppTheme.lightTheme,  // Apply our custom theme
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/intermediary': (context) => const IntermediaryPage(),
        '/game': (context) => const GamePage(),
        '/energy_game': (context) => HomeScreen(),
      },
    );
  }
}
