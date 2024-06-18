
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/groups/add_group.dart';
import 'package:elms/pages/groups/assign_students_to_group.dart';
import 'package:elms/pages/groups/edit_group.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/find_my_role.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/menu_item.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    Get.put(GroupController());
    super.initState();
  }

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Groups", actions: [
        if(userController.loggedInAs.value?.role == "Lecture")
        GestureDetector(
            onTap: () {
              Get.to(() => const AddGroup());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<GroupController>(
          init: GroupController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.groups
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedGroup.value = item;
                                 Get.bottomSheet(bottomSheetTemplate(widget: Column(children: [
                                  heading("Menu"),
                                  menuItem(title: "Group members",onTap: (){
                                     Get.to(()=>const AssignStudentToGroup());
                                  }),
                                      if(userController.loggedInAs.value?.role == "Lecture")
                                  menuItem(title: "Edit group",onTap: (){
                                     Get.to(()=>const EditGroup());
                                  })
                                 ],)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          border: Border.all(color: border)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Row(
                                            children: [
                                               ClipOval(
                                              child: Container(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(7),
                                                  child: Icon(
                                                    OctIcons.people,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    paragraph(item.name),
                                                   mutedText(formatDate(item.createdAt.toDate()))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
                )
              ]),
            );
          }),
    );
  }
}
