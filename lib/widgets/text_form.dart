import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';

Widget textForm(label, hint, {controller, obscureText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      paragraph(label, fontSize: 16),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: controller ?? TextEditingController(),
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
            border: OutlineInputBorder(
                gapPadding: 1,
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent)),
            hintText: hint),
      )
    ],
  );
}
