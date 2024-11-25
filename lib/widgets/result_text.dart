import 'package:flutter/material.dart';

class ResultText extends StatelessWidget {
  final String text;

  const ResultText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        color: Colors.yellow,
      ),
    );
  }
}
