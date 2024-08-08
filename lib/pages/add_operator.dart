// ignore_for_file: unused_import

import 'dart:math';

import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/operator_controller.dart';
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

class AddOperator extends StatefulWidget {
  const AddOperator({super.key});

  @override
  State<AddOperator> createState() => _AddOperatorState();
}

class _AddOperatorState extends State<AddOperator> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController roleController = TextEditingController(text: "Select address");
  List<String> roles = ["Select address", "Dar es salaam", "Dodoma", "Iringa","Mbeya","Mwanza","Arusha","Kilimanjaro","Tanga","Morogoro","Kigoma","Ruvuma","Singida","Tabora","Shinyanga","Manyara","Lindi","Mara","Pwani","Katavi","Geita","Simiyu","Njombe","Kagera","Zanzibar","Kusini Pemba","Kaskazini Pemba","Kusini Unguja","Kaskazini Unguja"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Add a operator"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              mutedText(text: "Fill your details below"),
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
                          child: heading("Operator's details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                        
                      TextForm(
                          hint: "Full name",
                          textEditingController: nameController,
                          label: "Enter full name"),
                      TextForm(
                          hint: "Enter phone number",
                          textEditingController: phoneController,
                          label: "Phone"),
                     TextForm(
                          hint: "Enter email address",
                          textEditingController: emailController,
                          label: "Email address"),
                       TextForm(
                          hint: "Enter password",
                          textEditingController: passwordController,
                          label: "password"),
                         
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customButton("Add operator",
                  onClick: () {
                        if (nameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            emailController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense");
                          }
                        else
                          {
                            OperatorController().addOperator(
                              name: nameController.text,
                              password: passwordController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            ).then((value) {
                              // Get.back();
                            });
                           Get.back();
                          }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
