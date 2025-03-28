import 'package:flutter/material.dart';

class GuessRecord {
  final String guess;
  final String feedback;

  GuessRecord(this.guess, this.feedback);
}

class GuessHistoryWidget extends StatelessWidget {
  final List<GuessRecord> guesses;

  const GuessHistoryWidget({Key? key, required this.guesses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Guesses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...guesses.map((record) => _buildGuessRecord(record)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuessRecord(GuessRecord record) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${record.guess}: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(record.feedback),
          ),
        ],
      ),
    );
  }
}
