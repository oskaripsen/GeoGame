import 'package:flutter/material.dart';
import '../models/category.dart';

class IntermediaryPage extends StatelessWidget {
  const IntermediaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Rules for ${category.name}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Text(
              category.description,
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'You will need to guess the correct answer from multiple choices. Each correct answer gives you points!',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: category,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
