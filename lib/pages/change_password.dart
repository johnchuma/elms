// ignore_for_file: unused_import

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

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

UserController userController = Get.find();

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Change password"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Your current assigned password is 123456, change it to a new password"),
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
                          child: heading("New password", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                   
                      TextForm(
                          hint: "Enter new password",
                          isPassword: true,
                          textEditingController: passwordController,
                          label: "new password"),
                          TextForm(
                          hint: "Re-enter password",
                          isPassword: true,
                          textEditingController: passwordController2,
                          label: "Repeat password"),
                    
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customButton("Save Changes",
                  onClick: () => {
                        if (passwordController.text.isEmpty != passwordController2.text.isEmpty)
                          {
                            Get.snackbar("Unmatch passwords",
                                "Please enter the same password on both fields")
                          }
                        else
                          {
                            userController.updateUser({
                              "password": passwordController.text,
                            }).then((value) {
                              User user = FirebaseAuth.instance.currentUser!;
                              user.reauthenticateWithCredential(EmailAuthProvider.credential(email: userController.loggedInAs!.email, password: userController.loggedInAs!.password));
                              user.updatePassword(passwordController.text);
                                  
                              Get.back();
                            })
                          }
                      }),
              const SizedBox(
                height: 10,
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
