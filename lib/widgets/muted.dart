import 'package:flutter/material.dart';

Widget mutedText(text,    {color, fontWeight, double? fontSize, int? maxLines, textAlign}) {
  return Text(
    text,
    maxLines: maxLines ?? 100,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 14,
        color: color ?? Colors.grey),
  );
}
