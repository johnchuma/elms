import 'package:elms/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/back.dart';
import 'package:elms/widgets/heading.dart';

PreferredSizeWidget appbar(context, {title, actions}) {
  return AppBar(
    leading: Container(),
    backgroundColor: AppColors.primaryColor,
    elevation: 0.3,
    leadingWidth: 1,
    actions: actions ?? [],
    title: Row(
      children: [
        back(context),
        const SizedBox(
          width: 20,
        ),
        Expanded(child: heading(title,color: Colors.white, maxLines: 1)),
      ],
    ),
  );
}
