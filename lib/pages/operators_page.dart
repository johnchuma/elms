
import 'package:elms/controllers/operator_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/add_farmer.dart';
import 'package:elms/pages/add_operator.dart';
import 'package:elms/pages/edit_operator.dart';
import 'package:elms/utils/app_colors.dart';

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

class OperatorsPage extends StatefulWidget {
  const OperatorsPage({Key? key}) : super(key: key);

  @override
  State<OperatorsPage> createState() => _OperatorsPageState();
}

class _OperatorsPageState extends State<OperatorsPage> {
  @override
  void initState() {
    Get.put(OperatorsPage());
    super.initState();
  }

  var category = "All".obs;
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    var role = userController.loggedInAs.value?.role;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Operators", actions: [
        if (role == "Admin")
          GestureDetector(
              onTap: () {
                Get.to(() => const AddOperator());
              },
              child: const Icon(Icons.add,color: Colors.white,)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetX<OperatorController>(
          init: OperatorController(),
          builder: (find) {
            return find.operators.isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.only(top: 20),
                        children: find.operators.map((item) {
                          return GestureDetector(
                            onTap: () {
                              find.selectedOperator = item;
                              Get.bottomSheet(bottomSheetTemplate(
                                  widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  heading("Menu"),
                                  menuItem(
                                      title: "Edit Operator",
                                      onTap: () {
                                        Get.back();
                                        Get.to(const EditOperator());
                                      }),
                                 
                                ],
                              )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(color: border)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          color: Colors.orange.withOpacity(0.1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.orange,
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
                                            heading(item.name,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            mutedText(text: item.email)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.help,size: 100,color:AppColors.primaryColor,),
              heading("No data available, Data will be displayed here",color: Color.fromARGB(255, 180, 182, 181),textAlign: TextAlign.center),
              ],
            );
          }
        )
      ),
    );
  }
}
