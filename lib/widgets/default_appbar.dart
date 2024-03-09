import 'package:elms/widgets/heading.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget defaultAppbar(page, {actions}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: heading(page),
    actions: actions ?? [],
  );
}
