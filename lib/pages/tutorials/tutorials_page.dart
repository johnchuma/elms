import 'package:elms/controllers/tutorial_controller.dart';
import 'package:elms/pages/tutorials/add_tutorial.dart';
import 'package:elms/pages/tutorials/edit_tutorial.dart';
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

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsState();
}

class _TutorialsState extends State<TutorialsPage> {
  @override
  void initState() {
    Get.put(TutorialController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Tutorials", actions: [
        if(currentUserRole() == "Lecture")
        GestureDetector(
            onTap: () {
              Get.to(() => const AddTutorial());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<TutorialController>(
          init: TutorialController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.tutorials
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedTutorial.value = item;
                                  Get.bottomSheet(bottomSheetTemplate(
                                      widget: Column(
                                    children: [
                                      heading("Menu"),
                                      menuItem(title: "View material",onTap: (){
                                        Get.back();
                                        downloadFile(link: item.link,name: item.path);
                                      }),
                                      if(currentUserRole() == "Lecture")
                                      menuItem(
                                          title: "Edit material",
                                          onTap: () {
                                            Get.back();
                                            Get.to(() => EditTutorial());
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
                                                    mutedText(item.introduction,
                                                        maxLines: 2),
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
