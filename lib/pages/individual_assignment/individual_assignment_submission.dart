import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/individual_assignment_controller.dart';
import 'package:elms/controllers/individual_submission_controller.dart';
import 'package:elms/controllers/quiz_submission_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/individual_assignment.dart';
import 'package:elms/models/submission.dart';
import 'package:elms/utils/colors.dart';
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
import 'package:get/get.dart';

class IndividualAssignmentSubmission extends StatefulWidget {
  const IndividualAssignmentSubmission({super.key});

  @override
  State<IndividualAssignmentSubmission> createState() =>
      _IndividualAssignmentSubmissionState();
}

class _IndividualAssignmentSubmissionState
    extends State<IndividualAssignmentSubmission> {
  IndividualAssignmentController individualassignmentController = Get.find();
  UserController userController = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? file;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    IndividualAssignment? individualassignment =
        individualassignmentController.selectedIndividualAssignment.value;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Assignment submission"),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Submission>>(
            stream: firestore
                .collection("submissions")
                .where("userId", isEqualTo: userController.loggedInAs?.id)
                .where("referenceId",
                    isEqualTo: individualassignmentController
                        .selectedIndividualAssignment.value?.id)
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
                              heading(individualassignment?.title),
                              const SizedBox(
                                height: 10,
                              ),
                              mutedText("Document"),
                              paragraph(individualassignment?.path,
                                  color: Colors.green),
                              const SizedBox(
                                height: 10,
                              ),
                              mutedText("Deadline"),
                              paragraph(formatDate(
                                  individualassignment!.deadline.toDate()))
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
                                  : file != null
                                      ? customButton("Submit", loading: loading,
                                          onClick: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          getLink(file).then((link) {
                                            // ignore: avoid_print
                                            print(link);

                                            IndividualAssignmentSubmissionController()
                                                .addSubmission(
                                                    link: link,
                                                    path: file?.path
                                                        .split('/')
                                                        .last,
                                                    refrenceId:
                                                        individualassignment.id,
                                                    userName: userController
                                                        .loggedInAs?.name,
                                                    userId: userController
                                                        .loggedInAs?.id);
                                          });
                                          individualassignmentController
                                              .updateIndividualAssignment({
                                            "students": [
                                              ...individualassignment.students,
                                              userController.loggedInAs?.id
                                            ]
                                          }).then((value) {
                                            setState(() {
                                              individualassignmentController
                                                  .selectedIndividualAssignment
                                                  .value
                                                  ?.students = [
                                                ...individualassignment
                                                    .students,
                                                userController.loggedInAs?.id
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
