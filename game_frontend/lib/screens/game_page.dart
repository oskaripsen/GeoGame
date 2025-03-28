import 'package:flutter/material.dart';
import '../models/category.dart';
import 'home_screen.dart';  // Import your energy game

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;
    
    // Direct both "Energy" and "Environment & Energy" to the real energy game
    if (category.name == 'Energy' || category.name == 'Environment & Energy') {
      return HomeScreen();
    }
    
    // Otherwise show the placeholder for other categories
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24.0),
            Text(
              '${category.name} Game',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'This is a placeholder for the actual game.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Return to Categories'),
            ),
          ],
        ),
      ),
    );
  }
}
