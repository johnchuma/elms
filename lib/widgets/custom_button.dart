import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';

Widget customButton(text, {onClick, background, loading, color}) {
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
                child: loading == true
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : paragraph(text,
                        fontWeight: FontWeight.bold,
                        color: color ?? Colors.white)),
          )),
    ),
  );
}
