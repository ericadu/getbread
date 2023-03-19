import 'package:flutter/material.dart';

class FixedHeightRoundedWideButton extends StatelessWidget {
  final String text;
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;

  const FixedHeightRoundedWideButton({
    required this.text,
    this.height = 38,
    this.onPressed,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: backgroundColor != null
                ? MaterialStateProperty.all(backgroundColor)
                : null,
            padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ))),
        onPressed: onPressed,
        child: SizedBox(
            height: height,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(text,
                  style: textStyle ??
                      const TextStyle(color: Colors.white, fontSize: 18)),
            ])));
  }
}
