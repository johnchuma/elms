// ignore_for_file: unused_import

import 'dart:io';

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/controllers/tutorial_controller.dart';
import 'package:elms/models/course_material.dart';
import 'package:elms/models/tutorial.dart';
import 'package:elms/utils/get_link.dart';
import 'package:elms/utils/pick_file.dart';
import 'package:file_picker/file_picker.dart';
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
class EditTutorial extends StatefulWidget {
  const EditTutorial({super.key});

  @override
  State<EditTutorial> createState() => _EditTutorialState();
}

TutorialController tutorialController = Get.find();

class _EditTutorialState extends State<EditTutorial> {
  Tutorial? tutorial = tutorialController.selectedTutorial.value;
  TextEditingController titleController = TextEditingController(
      text: tutorialController.selectedTutorial.value?.title);
  TextEditingController filesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController(
      text: tutorialController.selectedTutorial.value?.introduction);

  File? file;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit tutorials"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Edit tutorials"),
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
                          child: heading("Tutorials details",
                              color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter title",
                          textEditingController: titleController,
                          label: "Course title"),
                      TextForm(
                          hint: "Enter tutorial summary",
                          textEditingController: descriptionController,
                          lines: 5,
                          label: "Tutorial summary"),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              customButton("Save changes", loading: loading, onClick: () {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  Get.snackbar(
                      "Empty field", "Please fill the form to add course");
                } else {
                  setState(() {
                    loading = true;
                  });
                  tutorialController.updateTutorial({
                    "title": titleController.text,
                    "introduction": descriptionController.text
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Get.back();
                  });
                }
              }),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  tutorialController.deleteTutorial().then((value) {
                    Get.back();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading("Delete tutorial", color: Colors.red, fontSize: 14),
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
