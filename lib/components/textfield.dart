import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? labelTitle;
  final String textHint;
  final bool obscureText;
  final String? errorString;
  final ValueChanged<String>? onChanged;
  const AppTextField({
    super.key,
    required this.textHint,
    this.labelTitle,
    this.obscureText = false,
    this.errorString,
    this.onChanged,
    required bool obscuetext,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isVisible = false;

  @override
  void initState() {
    isVisible = !widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
        borderSide: const BorderSide(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(8));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelTitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelTitle ?? '',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        TextField(
          obscureText: widget.obscureText && !isVisible,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(maxHeight: 44),
              hintText: widget.textHint,
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              disabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility),
                    )
                  : null),
        ),
        if (widget.errorString != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorString ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
