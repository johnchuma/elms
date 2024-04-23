import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';

Widget customButton(text, {onClick, background, color}) {
  return GestureDetector(
    onTap: onClick ?? () {},
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
          width: double.infinity,
          color: background ?? AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
                child: paragraph(text,
                    fontWeight: FontWeight.bold, color: color ?? Colors.white)),
          )),
    ),
  );
}
