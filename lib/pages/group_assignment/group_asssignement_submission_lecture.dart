import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/group_assignment_submission_controller.dart';
import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/controllers/quiz_submission_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/quiz.dart';
import 'package:elms/models/submission.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/utils/get_extension_from_path.dart';
import 'package:elms/utils/pick_file.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:elms/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupAssignmentSubmissionLecture extends StatefulWidget {
  const GroupAssignmentSubmissionLecture({super.key});

  @override
  State<GroupAssignmentSubmissionLecture> createState() =>
      _GroupAssignmentSubmissionLectureState();
}

class _GroupAssignmentSubmissionLectureState
    extends State<GroupAssignmentSubmissionLecture> {
  // QuizController quizController = Get.find();
  UserController userController = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController marksController = TextEditingController();
  File? file;

  bool loading = false;
  GroupAssignmentSubmissionController submissionController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Quiz? quiz = quizController.selectedQuiz.value;
    Submission? submission = submissionController.selectedSubmission.value;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Assignment submission"),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Submission>>(
            stream: firestore
                .collection("submissions")
                .where("userId", isEqualTo: submission?.userId)
                .where("referenceId", isEqualTo: submission?.referenceId)
                .snapshots()
                .map((querySnapshot) {
              List<Submission> submissions = [];
              for (var element in querySnapshot.docs) {
                Submission submission =
                    Submission.fromDocumentSnapshot(element);
                submissions.add(submission);
              }
              return submissions;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              List<Submission> submissions = snapshot.requireData;
              Submission? submission;
              if (submissions.isNotEmpty) {
                submission = submissions.first;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(15),
                    //       border: Border.all(color: border)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(15),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           heading(quiz?.title),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           mutedText("Document"),
                    //           paragraph(quiz?.path, color: Colors.green),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           mutedText("Deadline"),
                    //           paragraph(formatDate(quiz!.deadline.toDate()))
                    //         ]),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: border)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heading("Submission"),
                              const SizedBox(
                                height: 30,
                              ),
                              if (submission == null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            pickDocument().then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  file = File(value.path!);
                                                });
                                              }
                                            });
                                          },
                                          child: file == null
                                              ? Column(
                                                  children: [
                                                    Icon(
                                                      Icons.upload_file,
                                                      color: mutedColor,
                                                      size: 60,
                                                    ),
                                                    mutedText("Pick document")
                                                  ],
                                                )
                                              : heading(
                                                  "${file?.path.split('/').last}",
                                                  color: Colors.green,
                                                  fontSize: 15)),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              submission != null
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            child: Image.asset(
                                                getExtensionFromPath(
                                                    submission.path)),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          mutedText(submission.path)
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (submission != null)
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(bottomSheetTemplate(
                              widget: Column(
                            children: [
                              heading("Write result"),
                              TextForm(
                                  label: "Enter marks",
                                  hint: "Enter quiz marks",
                                  textEditingController: marksController,
                                  textInputType: TextInputType.number),
                              customButton("Submit", onClick: () {
                                Get.back();
                                GroupAssignmentSubmissionController()
                                    .updateSubmission(submission?.id, {
                                  "marks": double.parse(marksController.text)
                                });
                              })
                            ],
                          )));
                        },
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: border)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heading("Results"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        submission.marks == 0
                                            ? mutedText("Marking.",
                                                fontSize: 20)
                                            : heading("${submission.marks}%",
                                                color: Colors.green,
                                                fontSize: 30),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (submission.marks == 0)
                                      customButton("Add results", onClick: () {
                                        Get.bottomSheet(bottomSheetTemplate(
                                            widget: Column(
                                          children: [
                                            heading("Write result"),
                                            TextForm(
                                                label: "Enter marks",
                                                hint: "Enter quiz marks",
                                                textEditingController:
                                                    marksController,
                                                textInputType:
                                                    TextInputType.number),
                                            customButton("Submit", onClick: () {
                                              Get.back();
                                              GroupAssignmentSubmissionController()
                                                  .updateSubmission(
                                                      submission?.id, {
                                                "marks": double.parse(
                                                    marksController.text)
                                              });
                                            })
                                          ],
                                        )));
                                      })
                                  ]),
                            )),
                      ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
