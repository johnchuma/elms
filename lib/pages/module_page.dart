import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/module.dart';
import 'package:elms/pages/announcements/announcements_page.dart';
import 'package:elms/pages/groups/groups_page.dart';
import 'package:elms/pages/learninghub_page.dart';
import 'package:elms/pages/lecture_room.dart';
import 'package:elms/pages/team_workspace.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ModulePage extends StatefulWidget {
  ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  ModuleController moduleController = Get.find();
  GroupController groupController = GroupController();
@override
  void initState() {
    Get.put(groupController);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Module? module = moduleController.selectedModule.value;
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      appBar: defaultAppbar("${module?.department} ${module?.code}"),
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
              {"title": "Lecture Room", "page":  LectureRoom()},
              {"title": "Team Workspace", "page":  TeamWorkspace()},
              {"title": "Anouncements", "page": const AnnouncementsPage()},
              {"title": "Groups", "page": const GroupsPage()},
            ]
                    .map((item) => GestureDetector(
                          onTap: () {
                            if(item["title"]=="Team Workspace"){
                               groupController.findMyGroup().then((value) {
                                if(value != null){
                                  groupController.selectedGroup.value = value;
                                  Get.to(()=>TeamWorkspace());
                                }else{
                                  Get.bottomSheet(bottomSheetTemplate(widget: Column(children: [
                                    heading("Oops!",color: Colors.red)
                                    ,mutedText("You are not assigned to any group yet")
                                  ],)));
                                }
                               });
                            }else{
                            Get.to(() => item["page"] as Widget);
                            }
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
