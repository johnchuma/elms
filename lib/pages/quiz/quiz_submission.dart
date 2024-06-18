import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/controllers/quiz_submission_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/quiz.dart';
import 'package:elms/models/submission.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/file_downloader.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/utils/get_extension_from_path.dart';
import 'package:elms/utils/get_link.dart';
import 'package:elms/utils/pick_file.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class QuizSubmission extends StatefulWidget {
  const QuizSubmission({super.key});

  @override
  State<QuizSubmission> createState() => _QuizSubmissionState();
}

class _QuizSubmissionState extends State<QuizSubmission> {
  QuizController quizController = Get.find();
  UserController userController = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? file;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Quiz? quiz = quizController.selectedQuiz.value;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Quiz submission"),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Submission>>(
            stream: firestore
                .collection("submissions")
                .where("userId", isEqualTo: userController.loggedInAs.value?.id)
                .where("referenceId",
                    isEqualTo: quizController.selectedQuiz.value?.id)
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
                    GestureDetector(
                      onTap: (){
                          downloadFile(link: quiz.link,name: quiz.path);
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
                                  ? GestureDetector(
                                    onTap: (){
                                        downloadFile(link: submission?.link,name: submission?.path);
                                    },
                                    child: SizedBox(
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
                                      ),
                                  )
                                  : file != null
                                      ? customButton("Submit", loading: loading,
                                          onClick: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          getLink(file).then((link) {
                                            // ignore: avoid_print
                                            print(link);

                                            QuizSubmissionController()
                                                .addSubmission(
                                                    link: link,
                                                    path: file?.path
                                                        .split('/')
                                                        .last,
                                                    refrenceId: quiz.id,
                                                    userName: userController
                                                        .loggedInAs.value?.name,
                                                    userId: userController
                                                        .loggedInAs.value?.id);
                                          });
                                          quizController.updateQuiz({
                                            "students": [
                                              ...quiz.students,
                                              userController.loggedInAs.value?.id
                                            ]
                                          }).then((value) {
                                            setState(() {
                                              quizController.selectedQuiz.value
                                                  ?.students = [
                                                ...quiz.students,
                                                userController.loggedInAs.value?.id
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
                    if (submission != null)
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      submission.marks == 0
                                          ? mutedText("Waiting...",
                                              fontSize: 30)
                                          : heading("${submission.marks}%",
                                              color: Colors.green,
                                              fontSize: 30),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ]),
                          )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
