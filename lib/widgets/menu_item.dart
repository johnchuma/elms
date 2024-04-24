// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/paragraph.dart';

Widget menuItem(
    {title,
    onTap,
    double? paddingTop,
    image,
    double? verticalPadding,
    Color? titleColor,
    bool? expandable = false,
    Widget? expandedItem}) {
  return Padding(
    padding: EdgeInsets.only(top: paddingTop ?? 5, bottom: 5),
    child: GestureDetector(
      onTap: onTap ?? () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:
                paragraph(title, color: titleColor ?? textColor, fontSize: 16),
          ),
          Icon(
            Icons.arrow_forward,
            color: mutedColor,
          )
        ],
      ),
    ),
  );
}
