

import 'package:elms/controllers/price_controller.dart';
import 'package:elms/controllers/record_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/bloototh_discovery.dart';
import 'package:elms/pages/groups_page.dart';
import 'package:elms/pages/login_page.dart';
import 'package:elms/pages/my_records.dart';
import 'package:elms/pages/records_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/heading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController = Get.find();
  @override
  void initState() {
  requestPermissions();
  Get.put(PriceController());
    super.initState();
  }
  requestPermissions() async{
    await Permission.location.request();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
     drawer: Drawer(child: drawer(),),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
         leading: Builder(
           builder: (context) {
             return IconButton(
              icon: const Icon(AntDesign.menu_outline,color: Colors.white,size: 20,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
           }
         ),
        elevation: 0,
        title: GestureDetector(
          onTap: (){
            Get.to(()=>const LoginPage());
          },
          child: heading("Home",color: Colors.white)),
        actions: const [],
      ),
      body: Scaffold(body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: userController.loggedInAs.value?.role == "Admin"?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AntDesign.user_outline,size: 100,color:AppColors.primaryColor,),
          heading("Welcome, System Admin",color: Color.fromARGB(255, 180, 182, 181),textAlign: TextAlign.center),
        const SizedBox(height: 20,),
         customButton("View Groups",onClick: (){
              Get.to(()=>const GroupsPage());
         })
        ],): userController.loggedInAs.value?.role == "Operator"? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AntDesign.user_outline,size: 100,color:AppColors.primaryColor,),
          heading("Welcome, Group Operator",color: Color.fromARGB(255, 180, 182, 181),textAlign: TextAlign.center),
        const SizedBox(height: 20,),
         customButton("View Assigned Groups",onClick: (){
              Get.to(()=>const GroupsPage());
         })
        ],): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AntDesign.user_outline,size: 100,color:AppColors.primaryColor,),
          heading("Welcome, Farmer",color: Color.fromARGB(255, 180, 182, 181),textAlign: TextAlign.center),
        const SizedBox(height: 20,),
         customButton("View Records",onClick: (){
              Get.to(()=>const MyRecords());
         })
        ],),
      ),),
    );
  }
}
