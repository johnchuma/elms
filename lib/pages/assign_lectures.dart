import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/module.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignLectures extends StatefulWidget {
  const AssignLectures({super.key});

  @override
  State<AssignLectures> createState() => _AssignLecturesState();
}

class _AssignLecturesState extends State<AssignLectures> {
  ModuleController moduleController = Get.find();
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;
  @override
  void initState() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    _subscription = firebaseFirestore
        .collection("modules")
        .doc(moduleController.selectedModule.value?.id)
        .snapshots()
        .listen((event) {
      moduleController.selectedModule.value =
          Module.fromDocumentSnapshot(event);
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
            "Assign lectures to ${moduleController.selectedModule.value?.department} ${moduleController.selectedModule.value?.code}",
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
                            .where((element) => element.role == "Lecture")
                            .map((e) => Padding(
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
                                          moduleController.selectedModule.value!
                                                  .teachers
                                                  .contains(e.id)
                                              ? GestureDetector(
                                                  onTap: () {
                                                    moduleController
                                                        .selectedModule
                                                        .value!
                                                        .teachers
                                                        .remove(e.id);
                                                    moduleController
                                                        .updateModule({
                                                      "teachers": [
                                                        ...moduleController
                                                            .selectedModule
                                                            .value!
                                                            .teachers
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
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: paragraph(
                                                              "Assigned",
                                                              fontSize: 13),
                                                        )),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    moduleController
                                                        .selectedModule
                                                        .value!
                                                        .teachers
                                                        .add(e.id);
                                                    moduleController
                                                        .updateModule({
                                                      "teachers": [
                                                        ...moduleController
                                                            .selectedModule
                                                            .value!
                                                            .teachers
                                                      ]
                                                    });
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                        color: Colors.grey[100],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
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
