import 'package:elms/pages/add_student.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: appbar(context, title: "Students", actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => AddStudent());
              },
              child: const Icon(Icons.add)),
          const SizedBox(
            width: 20,
          )
        ]),
        body: Column(
          children: [Container()],
        ));
  }
}
