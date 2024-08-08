// ignore_for_file: unused_import

import 'dart:math';

import 'package:elms/controllers/auth_controlller.dart';
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

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit users"),
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
                          child: heading("User details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter user name",
                          textEditingController: nameController,
                          label: "User name"),
                      TextForm(
                          hint: "Enter user email address",
                          textEditingController: emailController,
                          label: "Email address"),
                      TextForm(
                          label: "Phone",
                          textEditingController: phoneController,
                          hint: "Enter phone number"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter password",
                          textEditingController: passwordController,
                          isPassword: true,
                          label: "Password"),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customButton("Save Changes",
                  onClick: () => {
                        if (nameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            emailController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense")
                          }
                        else
                          {
                            // UserController()
                            //     .EditUser(
                            //   name: nameController.text,
                            //   password: passwordController.text,
                            //   email: emailController.text,
                            // )
                            //     .then((value) {
                            //   FirebaseAuth.instance
                            //       .createUserWithEmailAndPassword(
                            //           email: emailController.text,
                            //           password: passwordController.text);

                            //   Get.back();
                            // })
                          }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
