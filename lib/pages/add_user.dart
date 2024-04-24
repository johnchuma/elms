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
class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController roleController = TextEditingController(text: "Student");
  TextEditingController departmentController =
      TextEditingController(text: "ETE");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Add user"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Add new user"),
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
                          child: heading("User details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      selectForm(
                          onChanged: () {
                            setState(() {});
                          },
                          items: ["Student", "Lecture", "Admin"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: paragraph(e),
                                  ))
                              .toList(),
                          textEditingController: roleController,
                          label: "User role"),
                      TextForm(
                          hint: "Enter user name",
                          textEditingController: nameController,
                          label: "User name"),
                      TextForm(
                          hint: "Enter user phone number",
                          textEditingController: phoneController,
                          label: "Phone number"),
                      TextForm(
                          hint: "Enter user email address",
                          textEditingController: emailController,
                          label: "Email address"),
                      if (roleController.text == "Student")
                        TextForm(
                            hint: "Enter user registration number",
                            textEditingController: regController,
                            textInputType: TextInputType.number,
                            label: "Registration number"),
                      if (roleController.text == "Student")
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
                height: 20,
              ),
              customButton("Add User",
                  onClick: () => {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            emailController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense")
                          }
                        else
                          {
                            UserController()
                                .addUser(
                                    name: nameController.text,
                                    role: roleController.text,
                                    email: emailController.text,
                                    department: departmentController.text,
                                    phone: phoneController.text,
                                    reg: regController.text)
                                .then((value) {
                              Get.back();
                            })
                          }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
