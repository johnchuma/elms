import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/home_page.dart';
import 'package:elms/pages/login_page.dart';
import 'package:elms/pages/modules_page.dart';
import 'package:elms/pages/users_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/utils/find_my_role.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

Widget drawer() {
  return Builder(builder: (context) {
    return AnnotatedRegion(
      value:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              width: double.infinity,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(height: 70, child: Image.asset("assets/dit.png")),
                    const SizedBox(width: 10),
                    heading("DIT|e-LMS", color: Colors.white)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                  children: [
                {
                  "title": "Dashboard",
                  "iconData": OctIcons.home,
                  "roles":['Admin','Lecture','Student'],
                  "page": const HomePage()
                },
                {
                  "title": "System Users",
                  "iconData": OctIcons.people,
                  "roles":['Admin'],
                  "page": const StudentsPage()
                },
                {
                  "title": "Modules",
                  "iconData": OctIcons.apps,
                  "roles":['Admin'],
                  "page": const ModulesPage()
                },
                {
                  "title": "Logout",
                  "iconData": OctIcons.sign_out,
                  "roles":['Admin','Lecture','Student'],
                  "page": const LoginPage()
                }
              ].map((item) {
                List roles = item['roles'] as List;
                if(roles.contains(currentUserRole())){
                     return GestureDetector(
                  onTap: () {
                    if(item['title']!="Dashboard"){
                      Get.to(() => item["page"] as Widget);
                    }
                    else if(item['title']=="Logout"){
                      Navigator.pop(context);
                      Get.back();
                    }
                    else{
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              children: [
                                Icon(
                                  item["iconData"] as IconData,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                paragraph(item["title"],
                                    color: Colors.black87,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                }
                return  Container();
              }).toList()),
            )
          ],
        ),
      ),
    );
  });
}
