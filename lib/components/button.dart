import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function() onPress;
  final Color? color;
  const AppButton({
    super.key,
    required this.title,
    required this.onPress,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
