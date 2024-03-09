// ignore_for_file: unused_import

import 'package:elms/pages/home_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:elms/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/heading.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                              heading("Login to continue...", fontSize: 23),
                              const SizedBox(
                                height: 20,
                              ),
                              textForm("Registration number",
                                  "Enter registration number"),
                              const SizedBox(
                                height: 10,
                              ),
                              textForm("Password", "Enter your password",
                                  obscureText: true),
                              const SizedBox(
                                height: 20,
                              ),
                              customButton("Login", onClick: () {
                                Get.to(() => const HomePage());
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
