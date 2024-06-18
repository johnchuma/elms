import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/quiz/add_quiz.dart';
import 'package:elms/pages/quiz/edit_quiz.dart';
import 'package:elms/pages/quiz/quiz_submission.dart';
import 'package:elms/pages/quiz/view_quiz_submissions.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/find_my_role.dart';
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

class QuizzesAndTests extends StatefulWidget {
  const QuizzesAndTests({super.key});

  @override
  State<QuizzesAndTests> createState() => _QuizzesAndTestsState();
}

class _QuizzesAndTestsState extends State<QuizzesAndTests> {
  @override
  void initState() {
    Get.put(QuizController());
    super.initState();
  }

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Quizes and tests", actions: [
        if(userController.loggedInAs.value?.role == "Lecture")
        GestureDetector(
            onTap: () {
              Get.to(() => const AddQuiz());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<QuizController>(
          init: QuizController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.quizes
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedQuiz.value = item;
                                  Get.bottomSheet(bottomSheetTemplate(
                                      widget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      heading("Menu"),
                                      if(userController.loggedInAs.value?.role == "Lecture")
                                      menuItem(
                                          title: "View submissions",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() =>
                                                const ViewQuizSubmissions());
                                          }),
                                      menuItem(
                                          title: "Quiz submission",
                                          onTap: () {
                                            Get.back();
                                            Get.to(
                                                () => const QuizSubmission());
                                          }),
                                      if(userController.loggedInAs.value?.role == "Lecture")
                                      menuItem(
                                          title: "Edit quiz",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() => const EditQuiz());
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
                                                      .loggedInAs.value?.role ==
                                                  "Student")
                                                item.students.contains(
                                                        userController
                                                            .loggedInAs.value?.id)
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
