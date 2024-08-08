// ignore_for_file: non_constant_identifier_names
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';

Widget TextForm(
    {hint,
    key,
    TextEditingController? textEditingController,
    initialValue,
    TextInputType? textInputType,
    color,
    onChanged,
    label,
    validator,
    isPassword = false,
    int? lines,
    suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        paragraph(label ?? ""),
        const SizedBox(
          height: 5,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              color: background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextFormField(
                  obscureText: isPassword,
                  
                  initialValue: initialValue,
                  cursorColor: textColor,
                  onChanged: onChanged ?? (value) {},
                  keyboardType: textInputType ?? TextInputType.text,
                  style: TextStyle(color: textColor),
                  maxLines: lines ?? 1,
                  validator: validator ??
                      (value) {
                        if (value == "") {
                          return "Field required";
                        }
                        return null;
                      },
                  controller: textEditingController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: mutedColor),
                      suffixIcon: suffixIcon ??
                          Container(
                            width: 0,
                          ),
                      border: InputBorder.none,
                      hintText: hint),
                ),
              )),
        ),
      ],
    ),
  );
}
