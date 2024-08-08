import 'package:flutter/material.dart';

Widget heading(text,
    {color, fontWeight, double? fontSize, int? maxLines, textAlign}) {
  return Text(
    text,
    maxLines: maxLines ?? 100,
    overflow: TextOverflow.ellipsis,
    textAlign: textAlign ?? TextAlign.start,
    style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: fontSize ?? 20,
        color: color ?? Colors.black87),
  );
}
