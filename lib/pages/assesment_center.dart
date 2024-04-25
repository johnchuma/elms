import 'package:elms/pages/group_assignment/group_assignments.dart';
import 'package:elms/pages/individual_assignment/individual_assignments.dart';
import 'package:elms/pages/quiz/quizzes_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssesmentCenter extends StatelessWidget {
  const AssesmentCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      appBar: defaultAppbar("Assesment Center"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
                children: [
              {
                "title": "Individual assignment",
                "page": const IndividualAssignments()
              },
              {"title": "Group assignment", "page": const GroupAssignments()},
              {"title": "Quiz", "page": const QuizzesAndTests()}
            ]
                    .map((item) => GestureDetector(
                          onTap: () {
                            Get.to(() => item["page"] as Widget);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: AppColors.primaryColor,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: paragraph(item["title"],
                                        color: Colors.white,
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList()),
          )
        ]),
      ),
    );
  }
}
