import 'package:flutter/material.dart';

class GuessInputWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const GuessInputWidget({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _GuessInputWidgetState createState() => _GuessInputWidgetState();
}

class _GuessInputWidgetState extends State<GuessInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter your guess',
            border: OutlineInputBorder(),
            hintText: 'Type a country name',
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.send,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              widget.onSubmit(value);
              _controller.clear();
            }
          },
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmit(_controller.text);
              _controller.clear();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Submit Guess',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
