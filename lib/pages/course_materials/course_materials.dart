// ignore_for_file: sized_box_for_whitespace

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/pages/course_materials/add_course_material.dart';
import 'package:elms/pages/course_materials/edit_course_material.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/file_downloader.dart';
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
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseMaterials extends StatefulWidget {
  const CourseMaterials({super.key});

  @override
  State<CourseMaterials> createState() => _CourseMaterialsState();
}

class _CourseMaterialsState extends State<CourseMaterials> {
  @override
  void initState() {
    Get.put(CourseMaterialController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Course Materials", actions: [
        if(userController.loggedInAs.value?.role == "Lecture")
        GestureDetector(
            onTap: () {
              Get.to(() => const AddCourseMaterial());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<CourseMaterialController>(
          init: CourseMaterialController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.coursematerials
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedCourseMaterial.value = item;
                                  Get.bottomSheet(bottomSheetTemplate(
                                      widget: Column(
                                    children: [
                                      heading("Menu"),
                                      menuItem(title: "View material",onTap: (){
                                        Get.back();
                                        downloadFile(link: item.link,name: item.path);
                                      }),
                                      if(userController.loggedInAs.value?.role == "Lecture")
                                      menuItem(
                                          title: "Edit material",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() => EditCourseMaterial());
                                          })
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
                                              Container(
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
                                                    mutedText(formatDate(item
                                                        .createdAt
                                                        .toDate()))
                                                  ],
                                                ),
                                              ),
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
