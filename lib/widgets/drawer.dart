import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/famers_page.dart';
import 'package:elms/pages/groups_page.dart';
import 'package:elms/pages/home_page.dart';
import 'package:elms/pages/login_page.dart';
import 'package:elms/pages/my_records.dart';
import 'package:elms/pages/operators_page.dart';
import 'package:elms/pages/price_settings.dart';
import 'package:elms/pages/system_users.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

Widget drawer() {
  AuthController authController = Get.find();
  UserController userController = Get.find();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 70, child: Image.asset("assets/coffee.png")),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading("Coffee App", color: Colors.white),
                          mutedText(text: userController.loggedInAs.value?.email,color: Colors.white)
                        ],
                      ),
                    )
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
                  "roles":['Admin'],
                  "page": const HomePage()
                },
                 {
                  "title": "My Records",
                  "iconData": OctIcons.people,
                  "roles":['Farmer'],
                  "page": const MyRecords()
                },
                
                {
                  "title": "Groups",
                  "iconData": AntDesign.folder_open_outline,
                  "roles":['Admin',"Operator"],
                  "page": const GroupsPage()
                },
                 {
                  "title": "Price Settings",
                  "iconData": AntDesign.setting_outline,
                  "roles":['Admin'],
                  "page": const PriceSettings()
                },
                
                //  {
                //   "title": "Dashboard",
                //   "iconData": OctIcons.home,
                //   "roles":['Admin'],
                //   "page": const HomePage()
                // },
                 
                
                {
                  "title": "Logout",
                  "iconData": OctIcons.sign_out,
                  "roles":['Admin','Operator','Farmer'],
                  "page": const LoginPage()
                }
              ].map((item) {
                List roles = item['roles'] as List;
                if(roles.contains(userController.loggedInAs.value?.role)){
                     return GestureDetector(
                  onTap: () {
                    if(item['title']=="Logout"){
                      authController.auth.signOut();
                    }else{
                      if(item['title']!="Dashboard"){
                      Get.to(() => item["page"] as Widget);
                      }
                      else{
                        Navigator.pop(context);
                      }
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
