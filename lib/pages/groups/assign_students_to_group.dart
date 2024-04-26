import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/group.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignStudentToGroup extends StatefulWidget {
  const AssignStudentToGroup({super.key});

  @override
  State<AssignStudentToGroup> createState() => _AssignStudentToGroupState();
}

class _AssignStudentToGroupState extends State<AssignStudentToGroup> {
  GroupController groupController = Get.find();
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;

  @override
  void initState() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    _subscription = firebaseFirestore
        .collection("groups")
        .doc(groupController.selectedGroup.value?.id)
        .snapshots()
        .listen((event) {
      groupController.selectedGroup.value =
          Group.fromDocumentSnapshot(event);
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(
        context,
        title:
            "Assign students to ${groupController.selectedGroup.value?.name}",
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              GetX<UserController>(
                  init: UserController(),
                  builder: (find) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 85),
                      child: ListView(
                        children: find.users
                            .where((element) => element.role == "Student")
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    find.selectedUser = e;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          border: Border.all(color: border)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
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
                                                  heading(e.name),
                                                  mutedText(text: e.email)
                                                ],
                                              ),
                                            ),
                                            groupController.selectedGroup
                                                    .value!.students
                                                    .contains(e.id)
                                                ? GestureDetector(
                                                    onTap: () {
                                                      groupController
                                                          .selectedGroup
                                                          .value!
                                                          .students
                                                          .remove(e.id);
                                                      groupController
                                                          .updateGroup({
                                                        "students": [
                                                          ...groupController
                                                              .selectedGroup
                                                              .value!
                                                              .students
                                                        ]
                                                      });
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Container(
                                                          color:
                                                              Colors.green[100],
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: paragraph(
                                                                "Assigned",
                                                                fontSize: 13),
                                                          )),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      groupController
                                                          .selectedGroup
                                                          .value!
                                                          .students
                                                          .add(e.id);
                                                      groupController
                                                          .updateGroup({
                                                        "students": [
                                                          ...groupController
                                                              .selectedGroup
                                                              .value!
                                                              .students
                                                        ]
                                                      });
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Container(
                                                          color:
                                                              Colors.grey[100],
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: paragraph(
                                                                "Assign",
                                                                fontSize: 13),
                                                          )),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  }),
            ],
          )),
    );
  }
}
