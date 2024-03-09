import 'package:flutter/material.dart';

Widget paragraph(text,
    {color, fontWeight, double? fontSize, int? maxLines, textAlign}) {
  return Text(
    text,
    maxLines: maxLines ?? 100,
    overflow: TextOverflow.ellipsis,
    textAlign: textAlign ?? TextAlign.start,
    style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 16,
        color: color ?? Colors.black87),
  );
}
