// ignore_for_file: unused_import

import 'dart:io';

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/controllers/group_assignment_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/group_assignment.dart';
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
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddGroupAssignment extends StatefulWidget {
  const AddGroupAssignment({super.key});

  @override
  State<AddGroupAssignment> createState() => _AddGroupAssignmentState();
}

class _AddGroupAssignmentState extends State<AddGroupAssignment> {
  TextEditingController titleController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController filesController = TextEditingController();
  File? file;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Add Group Assignment"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Add new group assignment"),
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
                          child: heading("Group Assignment details",
                              color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter title",
                          textEditingController: titleController,
                          label: "Group Assignment title"),
                      datePicker(
                          label: "Deadline",
                          hint: "DD/MM/YYYY",
                          textEditingController: deadlineController),
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
                                            size: 60,
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
              customButton("Add group assignment", loading: loading,
                  onClick: () {
                if (titleController.text.isEmpty) {
                  Get.snackbar(
                      "Empty field", "Please fill the form to add course");
                } else {
                  setState(() {
                    loading = true;
                  });
                  getLink(file).then((url) {
                    GroupAssignmentController()
                        .addGroupAssignment(
                            title: titleController.text,
                            date: DateTime.parse(deadlineController.text),
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
