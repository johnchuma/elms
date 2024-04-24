// ignore_for_file: unused_import

import 'dart:io';

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/utils/get_link.dart';
import 'package:elms/utils/pick_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
class AddCourseMaterial extends StatefulWidget {
  const AddCourseMaterial({super.key});

  @override
  State<AddCourseMaterial> createState() => _AddCourseMaterialState();
}

class _AddCourseMaterialState extends State<AddCourseMaterial> {
  TextEditingController titleController = TextEditingController();
  TextEditingController filesController = TextEditingController();
  File? file;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Add course materials"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Add new couse material"),
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
                          child: heading("Course material details",
                              color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter title",
                          textEditingController: titleController,
                          label: "Course title"),
                      paragraph("File"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  pickDocument().then((value) {
                                    if (value != null) {
                                      setState(() {
                                        file = File(value.path!);
                                      });
                                    }
                                  });
                                },
                                child: file == null
                                    ? Column(
                                        children: [
                                          Icon(
                                            Icons.upload_file,
                                            color: mutedColor,
                                            size: 80,
                                          ),
                                          mutedText(text: "Pick document")
                                        ],
                                      )
                                    : heading("${file?.path.split('/').last}",
                                        color: Colors.green, fontSize: 15)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              customButton("Add course material", loading: loading,
                  onClick: () {
                if (titleController.text.isEmpty) {
                  Get.snackbar(
                      "Empty field", "Please fill the form to add course");
                } else {
                  setState(() {
                    loading = true;
                  });
                  getLink(file).then((url) {
                    CourseMaterialController()
                        .addCourseMaterial(
                            title: titleController.text,
                            path: file?.path.split('/').last,
                            link: url)
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Get.back();
                    });
                  });
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
