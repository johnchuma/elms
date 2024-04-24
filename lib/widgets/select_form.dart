// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/paragraph.dart';

Widget selectForm(
    {hint,
    key,
    TextEditingController? textEditingController,
    initialValue,
    TextInputType? textInputType,
    color,
    onChanged,
    label,
    List<DropdownMenuItem<String>>? items,
    validator,
    isPassword = false,
    int? lines,
    suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        paragraph(label ?? "Select"),
        const SizedBox(
          height: 5,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              color: background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButtonFormField(
                  items: items ?? [],
                  value: textEditingController!.text,
                  onChanged: (value) {
                    textEditingController.text = value.toString();
                    if (onChanged != null) {
                      onChanged();
                    }
                  },
                  style: TextStyle(color: textColor),
                  validator: validator ??
                      (value) {
                        if (value == "") {
                          return "Field required";
                        }
                        return null;
                      },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 15, color: mutedColor),
                      border: InputBorder.none,
                      hintText: hint),
                ),
              )),
        ),
      ],
    ),
  );
}
