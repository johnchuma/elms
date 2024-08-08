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

class EditOperator extends StatefulWidget {
  const EditOperator({super.key});

  @override
  State<EditOperator> createState() => _EditOperatorState();
}

class _EditOperatorState extends State<EditOperator> {
  OperatorController operatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: operatorController.selectedOperator?.name);
    TextEditingController emailController =
        TextEditingController(text: operatorController.selectedOperator?.email);
    TextEditingController passwordController = TextEditingController(
        text: operatorController.selectedOperator?.password);
    TextEditingController phoneController =
        TextEditingController(text: operatorController.selectedOperator?.phone);
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit operator"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              mutedText(text: "Fill operator's details below"),
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
                          child: heading("Operator's details",
                              color: Colors.white)),
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
                          textInputType: TextInputType.none,
                          label: "password"),
                      const SizedBox(
                        height: 10,
                      ),
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
              customButton("Save Changes",
                  onClick: () => {
                        if (nameController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense")
                          }
                        else
                          {
                            operatorController.updateOperator({
                              "name": nameController.text,
                              "password": passwordController.text,
                              "email": emailController.text,
                              "phone": phoneController.text,
                            }).then((res) {
                              Get.back();
                              Get.snackbar(
                                  "Success", "Changes Saved Successfully");
                            }),
                          }
                      }),
                      SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            operatorController.deleteOperator().then((value) {
                              Get.back();
                            });
                          },
                          child: heading("Delete Operator", color: Colors.red)),
                      ],
                    ),
SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
