// ignore_for_file: unused_import

import 'dart:math';

import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/price_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/date_picker.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:elms/widgets/select_form.dart';
import 'package:elms/widgets/text_form.dart';

class PriceSettings extends StatefulWidget {
  const PriceSettings({super.key});

  @override
  State<PriceSettings> createState() => _PriceSettingsState();
}

class _PriceSettingsState extends State<PriceSettings> {
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetX<PriceController>(
      init: PriceController(),
      builder: (find) {
        priceController.text = find.prices.first.price.toString();
        return Scaffold(
          backgroundColor: background,
          appBar: appbar(context, title: "price settings"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  mutedText(text: "Coffee price"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(color: border)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                              shaderCallback: (shader) {
                                return gradient.createShader(shader);
                              },
                              child: heading("Edit coffee price", color: Colors.white)),
                          const SizedBox(
                            height: 10,
                          ),
                          mutedText(text: find.prices.first.price.toString(),fontSize: 1),
                          TextForm(
                              hint: "Enter coffee price",
                              textEditingController: priceController,
                              label: "1kg coffee price "),
                         
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton("Save Changes",
                      onClick: () => {
                           PriceController().addPrice(price: double.parse(priceController.text)).then((value){
                              Get.back();
                           }),
                          })
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
