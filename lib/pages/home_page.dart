import 'package:elms/controllers/assigned_module_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/module_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/utils/find_my_role.dart';
import 'package:elms/widgets/drawer.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../widgets/heading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ModuleController moduleController = ModuleController();
  UserController userController = Get.find();
  @override
  void initState() {
    Get.put(moduleController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      drawer: Drawer(
        child: drawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: heading("Dashboard"),
        actions: const [],
      ),
      body: GetX<AssignedModuleController>(
          init: AssignedModuleController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      mutedText("Assigned modules",fontWeight: FontWeight.w400),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 20,
                                crossAxisCount: 2,
                                mainAxisSpacing: 20),
                        children:[...currentUserRole()=="Students"?find.studentsModules.toList():find.teachersModules.toList()].map((item) => GestureDetector(
                                  onTap: () {
                                    moduleController.selectedModule.value = item;
                                    Get.to(() => ModulePage());
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: AppColors.primaryColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          paragraph(
                                              "${item.department} ${item.code}",
                                              color: Colors.white),
                                          const SizedBox(height: 10),
                                          const Icon(
                                            OctIcons.apps,
                                            size: 45,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()),
                  )
                ]),
              ),
            );
          }),
    );
  }
}
