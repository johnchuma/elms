import 'package:elms/controllers/group_assignment_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/group_assignment/add_group_assignment.dart';
import 'package:elms/pages/group_assignment/edit_group_assignment.dart';
import 'package:elms/pages/quiz/edit_quiz.dart';
import 'package:elms/pages/group_assignment/group_assignment_submission.dart';
import 'package:elms/pages/quiz/quiz_submission.dart';
import 'package:elms/pages/group_assignment/view_group_assignment_submissions.dart';
import 'package:elms/pages/quiz/view_quiz_submissions.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/utils/get_extension_from_path.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/menu_item.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupAssignments extends StatefulWidget {
  const GroupAssignments({super.key});

  @override
  State<GroupAssignments> createState() => _GroupAssignmentsState();
}

class _GroupAssignmentsState extends State<GroupAssignments> {
  @override
  void initState() {
    Get.put(GroupAssignmentController());
    super.initState();
  }

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Group Assignments", actions: [
        GestureDetector(
            onTap: () {
              Get.to(() => const AddGroupAssignment());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<GroupAssignmentController>(
          init: GroupAssignmentController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.groupassignments
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedGroupAssignment.value = item;
                                  Get.bottomSheet(bottomSheetTemplate(
                                      widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heading("Menu"),
                                      menuItem(
                                          title: "View submissions",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() =>
                                                const ViewGroupAssignmentSubmissions());
                                          }),
                                      menuItem(
                                          title: "Assignment submission",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() =>
                                                const GroupAssignmentSubmission());
                                          }),
                                      menuItem(
                                          title: "Edit assignment",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() =>
                                                const EditGroupAssignment());
                                          }),
                                    ],
                                  )));
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
                                              SizedBox(
                                                  height: 30,
                                                  child: Image.asset(
                                                      getExtensionFromPath(
                                                          item.path))),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    paragraph(item.title),
                                                    mutedText(
                                                        "Deadline ${formatDate(item.deadline.toDate())}")
                                                  ],
                                                ),
                                              ),
                                              if (userController
                                                      .loggedInAs?.role ==
                                                  "Student")
                                                item.students.contains(
                                                        userController
                                                            .loggedInAs?.id)
                                                    ? heading("Submitted",
                                                        fontSize: 11,
                                                        color: Colors.green)
                                                    : heading("Not submited",
                                                        fontSize: 11,
                                                        color: Colors.red)
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
