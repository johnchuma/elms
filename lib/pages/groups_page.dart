import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/add_group.dart';
import 'package:elms/pages/edit_group.dart';
import 'package:elms/pages/famers_page.dart';
import 'package:elms/pages/operators_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/menu_item.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    Get.put(GroupController());
    super.initState();
  }

  var category = "All".obs;
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    var role = userController.loggedInAs.value?.role;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Groups", actions: [
        if (role == "Admin")
          GestureDetector(
              onTap: () {
                Get.to(() => const AddGroup());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<GroupController>(
          init: GroupController(),
          builder: (find) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: find.groups.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.only(top: 20),
                        children: find.groups.map((item) {
                          return GestureDetector(
                            onTap: () {
                              find.selectedGroup = item;
                              Get.bottomSheet(bottomSheetTemplate(
                                  widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  heading("Menu"),
                               if(role =="Admin")   menuItem(
                                      title: "Group Operators",
                                      onTap: () {
                                        Get.back();
                                        Get.to(const OperatorsPage());
                                      }),
                                  menuItem(
                                      title: "Group Members/Farmers",
                                      onTap: () {
                                        Get.back();
                                        Get.to(const FarmersPage());
                                      }),
                                if(role == "Admin")  menuItem(
                                      title: "Edit Group",
                                      onTap: () {
                                        Get.back();
                                        Get.to(() => const EditGroup());
                                      }),
                                ],
                              )));
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
                                              Icons.people,
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
                                            mutedText(text: item.address)
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
                              color: const Color.fromARGB(255, 180, 182, 181),
                              textAlign: TextAlign.center),
                        ],
                      ));
          }),
    );
  }
}
