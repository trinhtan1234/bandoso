import 'package:flutter/material.dart';

class AppTextButtom extends StatefulWidget {
  final Icon iconLeft;
  final String labelTitle;
  final Icon iconRight;
  final VoidCallback onPressed;

  const AppTextButtom({
    super.key,
    required this.iconLeft,
    required this.iconRight,
    required this.labelTitle,
    required this.onPressed,
  });

  @override
  State<AppTextButtom> createState() => _AppTextButtomState();
}

class _AppTextButtomState extends State<AppTextButtom> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.iconLeft, // Display iconLeft or an empty SizedBox
              const SizedBox(
                  width: 8.0), // Add some spacing between icon and label
              Text(widget.labelTitle), // Display labelTitle or an empty Text
              // Add some spacing between label and iconRight
              // Display iconRight or an empty SizedBox
            ],
          ),
          Container(
            child: widget.iconRight,
          ),
        ],
      ),
    );
  }
}
