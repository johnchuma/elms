import 'package:elms/controllers/farmer_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/add_farmer.dart';
import 'package:elms/pages/add_farmer.dart';
import 'package:elms/pages/edit_farmer.dart';
import 'package:elms/pages/records_page.dart';
import 'package:elms/utils/app_colors.dart';

import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/menu_item.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FarmersPage extends StatefulWidget {
  const FarmersPage({Key? key}) : super(key: key);

  @override
  State<FarmersPage> createState() => _FarmersPageState();
}

class _FarmersPageState extends State<FarmersPage> {
  @override
  void initState() {
    Get.put(FarmerController());
    super.initState();
  }

  var category = "All".obs;
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    var role = userController.loggedInAs.value?.role;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Farmers", actions: [
        if (role == "Operator")
          GestureDetector(
              onTap: () {
                Get.to(() => const AddFarmer());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        const SizedBox(
          width: 20,
        )
      ]),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GetX<FarmerController>(
              init: FarmerController(),
              builder: (find) {
                return find.farmers.isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.only(top: 20),
                        children: find.farmers.map((item) {
                          return GestureDetector(
                            onTap: () {
                              find.selectedFarmer = item;
                              if (role == "Operator") {
                                Get.bottomSheet(bottomSheetTemplate(
                                    widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heading("Menu"),
                                     menuItem(
                                        title: "Farmer records",
                                        onTap: () {
                                          Get.back();
                                          Get.to(const RecordsPage());
                                        }),
                                    menuItem(
                                        title: "Edit Farmer",
                                        onTap: () {
                                          Get.back();
                                          Get.to(const EditFarmer());
                                        }),
                                  ],
                                )));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(color: border)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          color: Colors.orange.withOpacity(0.1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            heading(item.name,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            mutedText(text: item.phone)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help,
                            size: 100,
                            color: AppColors.primaryColor,
                          ),
                          heading(
                              "No data available, Data will be displayed here",
                              color: Color.fromARGB(255, 180, 182, 181),
                              textAlign: TextAlign.center),
                        ],
                      );
              })),
    );
  }
}
