// ignore_for_file: must_be_immutable

import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/home_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  UserController userController = Get.find();
  AuthController authController = Get.find();
 @override
  void initState() {
    
    super.initState();
  }
  
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: userController.findUser(email: authController.auth.currentUser?.email),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
          }
         var data = snapshot.requireData;
         if(data == null){
            return  Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
         }
        userController.loggedInAs.value = data;
          return const HomePage();
        }
      ),
    );
  }
}