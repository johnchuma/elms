import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/add_user.dart';
import 'package:elms/pages/edit_user.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "System Users", actions: [
        GestureDetector(
            onTap: () {
              Get.to(() => const AddUser());
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
              GetX<UserController>(
                  init: UserController(),
                  builder: (find) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 85),
                      child: ListView(
                        children: find.users
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    find.selectedUser = e;
                                    Get.to(() => const EditUser());
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
                                                color: Colors.orange
                                                    .withOpacity(0.1),
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
                                                  heading(e.name,fontSize: 16,fontWeight: FontWeight.w400),
                                                  mutedText(text: e.email)
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
                    );
                  }),
            ],
          )),
    );
  }
}
