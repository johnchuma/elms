// ignore_for_file: unused_import

import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/add_user.dart';
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
  TextEditingController usernameController = TextEditingController();

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 100, child: Image.asset("assets/coffee.png")),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: heading("Coffee pricing and weighing management system", color: Colors.white,textAlign: TextAlign.center),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
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
                              heading("SignIn to continue", fontSize: 23),
                              const SizedBox(
                                height: 20,
                              ),
                              TextForm(
                                  label: "Username",
                                  textEditingController: usernameController,
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
                                if (usernameController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  Get.snackbar("Empty fields",
                                      "Please fill all fields to continue");
                                } else {
                                  // check if its valid email
                                  try {
                                    
                                  var user = await userController.findUserByUsername(name: usernameController.text.trim());
                                  print(user?.email);
                                  if (user != null) {
                                    if (user.password == passwordController.text) {
                                      FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: user.email.trim(),
                                        password:passwordController.text,
                                      );
                                      // Get.to(()=>const WayPage());
                                    } else {
                                      Get.snackbar("Wrong password", "You have entered the wrong password");
                                    }
                                  } else {
                                    Get.snackbar("Unregistered user", "This user is not registered");
                                  }
                                
                                  } catch (e) {
                                    print(e);
                                    throw e;
                                  }
                                
                              }},
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //   Text("Not registered ?"),
                              //   TextButton(
                              //       onPressed: () {
                              //         Get.to(()=>AddUser());
                              //       },
                              //       child: paragraph("Register",
                              //           color: AppColors.primaryColor)),
                              // ],)
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
