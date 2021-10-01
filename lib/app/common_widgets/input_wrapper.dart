import 'package:flutter/material.dart';

class InputWrapper extends StatelessWidget {
  final Widget child;
  final String label;
  final bool required;
  final bool dense;
  final bool filtering;
  final double? width;

  const InputWrapper(
      {Key? key, required this.child,
      required this.label,
      this.required = false,
      this.dense = false,
      this.filtering = false,
      this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              filtering ? label.toUpperCase() : label,
              style: labelStyle(context,
                  bold: filtering, fontSize: filtering ? 12 : 14),
            ),
            if (required)
              Text(
                ' *',
                style: labelStyle(context)?.copyWith(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          width: width,
          child: Padding(
            padding: EdgeInsets.only(bottom: dense ? 0.0 : 25),
            child: child,
          ),
        )
      ],
    );
  }
}

TextStyle? labelStyle(BuildContext context,
    {double fontSize = 12, bool bold = true}) {
  return Theme.of(context).textTheme.bodyText2?.copyWith(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal);
}
