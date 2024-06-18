import 'package:elms/controllers/module_controller.dart';
import 'package:elms/pages/add_module.dart';
import 'package:elms/pages/assign_lectures.dart';
import 'package:elms/pages/assign_students.dart';
import 'package:elms/pages/edit_module.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/menu_item.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  @override
  void initState() {
    super.initState();
  }
  var category = "All".obs;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Modules", actions: [
        GestureDetector(
            onTap: () {
              Get.to(() => const AddModule());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              GetX<ModuleController>(
                  init: ModuleController(),
                  builder: (find) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 85),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            child: ListView(
                               scrollDirection: Axis.horizontal,
                              children:["All","ETE", "ME", "CSE", "CE", "EE"].map((e) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: (){
                                      category.value = e;
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      color: category.value==e?Colors.blue.withOpacity(0.1): Colors.grey.withOpacity(0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                        child: paragraph(e),
                                      ),),
                                  ),
                                ),
                              )).toList())),
                              const SizedBox(height: 20,),
                          Expanded(
                            child: ListView(
                              children: find.modules.where((element) =>element.department.contains(category.value=="All"?"":category.value))
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          find.selectedModule.value = e;
                                          Get.bottomSheet(bottomSheetTemplate(
                                              widget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              heading("Menu"),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              menuItem(
                                                  title: "Assign students",
                                                  onTap: () {
                                                    Get.to(
                                                        () => const AssignStudents());
                                                  }),
                                              menuItem(
                                                  title: "Assign lectures",
                                                  onTap: () {
                                                    Get.to(
                                                        () => const AssignLectures());
                                                  }),
                                              menuItem(
                                                  title: "Edit module",
                                                  onTap: () {
                                                    Get.to(() => const EditModule());
                                                  })
                                            ],
                                          )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                                border: Border.all(color: border)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 15),
                                              child: Row(
                                                children: [
                                                  ClipOval(
                                                    child: Container(
                                                      color:
                                                          Colors.red.withOpacity(0.1),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(7),
                                                        child: Icon(
                                                          Icons.view_module,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        heading(e.name,fontSize: 16,fontWeight: FontWeight.w400),
                                                        mutedText(
                                                            text:
                                                                "${e.department} ${e.code}")
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          )),
    );
  }
}
