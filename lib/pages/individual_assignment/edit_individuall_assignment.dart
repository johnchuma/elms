// ignore_for_file: unused_import

import 'dart:io';

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/controllers/individual_assignment_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/individual_assignment.dart';
import 'package:elms/utils/format_date.dart';
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
class EditIndividualAssignment extends StatefulWidget {
  const EditIndividualAssignment({super.key});

  @override
  State<EditIndividualAssignment> createState() =>
      _EditIndividualAssignmentState();
}

class _EditIndividualAssignmentState extends State<EditIndividualAssignment> {
  File? file;
  bool loading = false;
  IndividualAssignmentController individualassignmentController = Get.find();

  @override
  Widget build(BuildContext context) {
    IndividualAssignment? individualassignment =
        individualassignmentController.selectedIndividualAssignment.value;
    TextEditingController titleController =
        TextEditingController(text: individualassignment?.title);
    TextEditingController deadlineController = TextEditingController(
        text: formDateFormat(individualassignment!.deadline.toDate()));
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit Assignment"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Edit assignment details"),
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
                          child: heading("Assignment details",
                              color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter title",
                          textEditingController: titleController,
                          label: "Assignment title"),
                      datePicker(
                          label: "Deadline",
                          hint: "DD/MM/YYYY",
                          textEditingController: deadlineController),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              customButton("Edit assignment", loading: loading, onClick: () {
                if (titleController.text.isEmpty) {
                  Get.snackbar(
                      "Empty field", "Please fill the form to add course");
                } else {
                  setState(() {
                    loading = true;
                  });
                  individualassignmentController.updateIndividualAssignment({
                    "title": titleController.text,
                    "deadline": DateTime.parse(deadlineController.text)
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
                  individualassignmentController
                      .deleteIndividualAssignment()
                      .then((value) {
                    Get.back();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading("Delete Assignment",
                        color: Colors.red, fontSize: 14),
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
