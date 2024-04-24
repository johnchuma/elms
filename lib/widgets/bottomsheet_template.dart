import 'package:flutter/material.dart';
import 'package:elms/utils/colors.dart';

Widget bottomSheetTemplate({widget}) {
  return SingleChildScrollView(
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 80,
                        height: 5,
                        color: background,
                      ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              widget,
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
