// ignore_for_file: unused_import

import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/change_password.dart';
import 'package:elms/pages/home_page.dart';
import 'package:elms/pages/waypage.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:elms/widgets/text_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/heading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 150, child: Image.asset('assets/dit.png')),
                      const SizedBox(height: 10),
                      heading("DIT|e-LMS", color: Colors.white)
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height / 2 + 50,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              heading("Login to continue", fontSize: 23),
                              const SizedBox(
                                height: 20,
                              ),
                              TextForm(
                                  label: "Email address",
                                  textEditingController: emailController,
                                  hint: "Enter email address"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextForm(
                                label: "Password",
                                textEditingController: passwordController,
                                isPassword: true,
                                hint: "Enter your password",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              customButton("Login", onClick: () async {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  Get.snackbar("Empty fields",
                                      "Please fill all fields to continue");
                                } else {
                                  var user = await userController.findUser(
                                      email: emailController.text);

                                  if (user != null) {
                                    if (user.password ==
                                        passwordController.text) {
                                        FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      // Get.to(()=>const WayPage());
                                    } else {
                                      Get.snackbar("Wrong password",
                                          "Your have entered the wrong password");
                                    }
                                  } else {
                                    Get.snackbar("Unregistered email",
                                        "This user is not registered");
                                  }
                                }
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
