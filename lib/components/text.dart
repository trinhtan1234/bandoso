import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const AppText({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
