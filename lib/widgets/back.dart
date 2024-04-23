import 'package:flutter/material.dart';
import 'package:elms/utils/colors.dart';

Widget back(context, {Color? color}) {
  return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
          color: Colors.transparent,
          child: Icon(
            Icons.arrow_back,
            color: color ?? mutedColor,
            size: 20,
          )));
}
