import 'package:elms/controllers/group_assignment_submission_controller.dart';
import 'package:elms/controllers/quiz_submission_controller.dart';
import 'package:elms/pages/quiz/add_quiz.dart';
import 'package:elms/pages/group_assignment/group_asssignement_submission_lecture.dart';
import 'package:elms/pages/quiz/quiz_submission_lecture.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/utils/get_extension_from_path.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewGroupAssignmentSubmissions extends StatefulWidget {
  const ViewGroupAssignmentSubmissions({super.key});

  @override
  State<ViewGroupAssignmentSubmissions> createState() =>
      _ViewSubmissionsState();
}

class _ViewSubmissionsState extends State<ViewGroupAssignmentSubmissions> {
  @override
  void initState() {
    Get.put(GroupAssignmentSubmissionController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Assignment Submissions", actions: [
        GestureDetector(
            onTap: () {
              Get.to(() => const AddQuiz());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<GroupAssignmentSubmissionController>(
          init: GroupAssignmentSubmissionController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.submissions
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedSubmission.value = item;
                                  Get.to(() =>
                                      const GroupAssignmentSubmissionLecture());
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
                                                    paragraph(item.userName),
                                                    mutedText(
                                                        "Submitted ${formatDate(item.createdAt.toDate())}")
                                                  ],
                                                ),
                                              ),
                                              item.marks == 0.0
                                                  ? mutedText("Unmarked",
                                                      fontSize: 11)
                                                  : heading("${item.marks}%",
                                                      fontSize: 14,
                                                      color: Colors.green)
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
