import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/login_page.dart';
import 'package:elms/pages/user_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WayPage extends StatefulWidget {
  const WayPage({super.key});

  @override
  State<WayPage> createState() => _WayPageState();
}

class _WayPageState extends State<WayPage> {

  @override
  void initState() {
    Get.put(UserController());
    Get.put(AuthController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      init:AuthController(),
      builder: (find) {
        return find.user != null? UserDetailsPage():const LoginPage();
      }
    );
  }
}