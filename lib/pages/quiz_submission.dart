import 'dart:io';

import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/controllers/submission_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/quiz.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/utils/get_link.dart';
import 'package:elms/utils/pick_file.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizSubmission extends StatefulWidget {
  const QuizSubmission({super.key});

  @override
  State<QuizSubmission> createState() => _QuizSubmissionState();
}

class _QuizSubmissionState extends State<QuizSubmission> {
  QuizController quizController = Get.find();
  UserController userController = Get.find();

  File? file;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Quiz? quiz = quizController.selectedQuiz.value;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Quiz submission"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
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
                      heading(quiz?.title),
                      const SizedBox(
                        height: 10,
                      ),
                      mutedText("Document"),
                      paragraph(quiz?.path, color: Colors.green),
                      const SizedBox(
                        height: 10,
                      ),
                      mutedText("Deadline"),
                      paragraph(formatDate(quiz!.deadline.toDate()))
                    ]),
              ),
            ),
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
                      heading("My Submission"),
                      const SizedBox(
                        height: 30,
                      ),
                      if (!quiz.students
                          .contains(userController.selectedUser?.id))
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
                                      : heading("${file?.path.split('/').last}",
                                          color: Colors.green, fontSize: 15)),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      quiz.students.contains(userController.selectedUser?.id)
                          ? SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.green,
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  mutedText("Submited successfully")
                                ],
                              ),
                            )
                          : file != null
                              ? customButton("Submit", onClick: () {
                                  getLink(file).then((link) => {
                                        SubmissionController().addSubmission(
                                            link: link,
                                            marks: null,
                                            path: file?.path.split('/').last,
                                            refrenceId: quiz.id,
                                            userName: userController
                                                .selectedUser?.name,
                                            userId:
                                                userController.selectedUser?.id)
                                      });
                                  quizController.updateQuiz({
                                    "students": [
                                      ...quiz.students,
                                      userController.selectedUser?.id
                                    ]
                                  }).then((value) {
                                    setState(() {
                                      quizController
                                          .selectedQuiz.value?.students = [
                                        ...quiz.students,
                                        userController.selectedUser?.id
                                      ];
                                    });
                                  });
                                })
                              : Container(),
                    ]),
              ),
            ),
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
                      heading("Results"),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
