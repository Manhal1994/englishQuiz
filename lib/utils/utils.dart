import 'package:flutter/material.dart';

double getTexWidth(BuildContext context, String text, TextStyle style) {
  return (TextPainter(
              text: TextSpan(text: text, style: style),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size
          .width +
      44;
}

