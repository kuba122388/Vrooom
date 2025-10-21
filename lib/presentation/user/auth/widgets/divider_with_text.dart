import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          height: 1,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(text),
        ),
        const Expanded(
            child: Divider(
          height: 1,
        )),
      ],
    );
  }
}
