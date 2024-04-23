// ignore_for_file: unused_import

import 'package:elms/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/date_picker.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:elms/widgets/select_form.dart';
import 'package:elms/widgets/text_form.dart';

// ignore: must_be_immutable
class AddStudent extends StatelessWidget {
  AddStudent({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController departmentController =
      TextEditingController(text: "ETE");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Add Student"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Add new student"),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: border)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                          shaderCallback: (shader) {
                            return gradient.createShader(shader);
                          },
                          child:
                              heading("Student details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter student name",
                          textEditingController: nameController,
                          label: "Student name"),
                      TextForm(
                          hint: "Enter student phone number",
                          textEditingController: phoneController,
                          label: "Phone number"),
                      TextForm(
                          hint: "Enter student registration number",
                          textEditingController: regController,
                          label: "Registration number"),
                      selectForm(
                          items: ["ETE", "ME", "CSE", "CE", "EE"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: paragraph(e),
                                  ))
                              .toList(),
                          textEditingController: departmentController,
                          label: "Select department")
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              customButton("Add Student",
                  onClick: () => {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            regController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense")
                          }
                        else
                          {
                            UserController().addUser(
                                name: nameController.text,
                                department: departmentController.text,
                                phone: phoneController.text,
                                reg: regController.text)
                          }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
