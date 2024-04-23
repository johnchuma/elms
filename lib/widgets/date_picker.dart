// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/widgets/paragraph.dart';

Widget datePicker(
    {hint,
    key,
    TextEditingController? textEditingController,
    initialValue,
    TextInputType? textInputType,
    color,
    onChanged,
    label,
    selectedDate,
    validator,
    isPassword = false,
    int? lines,
    suffixIcon}) {
  Rx<DateTime?> date = Rx<DateTime?>(null);
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
                child: Builder(builder: (context) {
                  return TextFormField(
                    obscureText: isPassword,
                    initialValue: initialValue,
                    onTap: () async {
                      date.value = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 100000)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 1000)));
                      if (date.value != null) {
                        textEditingController?.text =
                            formDateFormat(date.value!);
                      }
                    },
                    cursorColor: textColor,
                    onChanged: onChanged ?? (value) {},
                    keyboardType: textInputType ?? TextInputType.none,
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
                  );
                }),
              )),
        ),
      ],
    ),
  );
}
