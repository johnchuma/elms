import 'package:elms/pages/assesment_center.dart';
import 'package:elms/pages/course_materials/course_materials.dart';
import 'package:elms/pages/tutorials/tutorials_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearningHubPage extends StatelessWidget {
  const LearningHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      appBar: defaultAppbar("Learning Hub"),
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
              {"title": "Course materials", "page": const CourseMaterials()},
              {"title": "Tutorials", "page": const TutorialsPage()},
              {"title": "Assesment center", "page": const AssesmentCenter()}
            ]
                    .map((item) => GestureDetector(
                          onTap: () {
                            Get.to(
                                () => Container(child: item["page"] as Widget));
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
