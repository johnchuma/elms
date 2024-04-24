// ignore_for_file: unused_import

import 'package:elms/controllers/module_controller.dart';
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
class EditModule extends StatefulWidget {
  const EditModule({super.key});

  @override
  State<EditModule> createState() => _EditModuleState();
}

ModuleController moduleController = Get.find();

class _EditModuleState extends State<EditModule> {
  TextEditingController nameController =
      TextEditingController(text: moduleController.selectedModule.value?.name);
  TextEditingController codeController =
      TextEditingController(text: moduleController.selectedModule.value?.code);
  TextEditingController departmentController = TextEditingController(
      text: moduleController.selectedModule.value?.department);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit modules"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Edit module details"),
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
                              heading("Module details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter module name",
                          textEditingController: nameController,
                          label: "Module name"),
                      TextForm(
                          hint: "Enter module code",
                          textEditingController: codeController,
                          label: "Module code"),
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
                height: 40,
              ),
              customButton("Save changes",
                  onClick: () => {
                        if (nameController.text.isEmpty ||
                            codeController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add module")
                          }
                        else
                          {
                            moduleController.updateModule({
                              "name": nameController.text,
                              "department": departmentController.text,
                              "code": codeController.text
                            }).then((value) {
                              Get.back();
                            })
                          }
                      }),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  moduleController.deleteModule().then((value) {
                    Get.back();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading("Delete Module", color: Colors.red, fontSize: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
