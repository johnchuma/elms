import 'package:elms/pages/announcements.dart';
import 'package:elms/pages/learninghub_page.dart';
import 'package:elms/pages/lecture_room.dart';
import 'package:elms/pages/team_workspace.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModulePage extends StatelessWidget {
  const ModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      appBar: defaultAppbar("ETE 23093"),
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
              {"title": "Learning Hub", "page": const LearningHubPage()},
              {"title": "Lecture Room", "page": const LectureRoom()},
              {"title": "Team Workspace", "page": const TeamWorkspace()},
              {"title": "Anouncements", "page": const Anouncements()},
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
