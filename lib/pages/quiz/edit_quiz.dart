// ignore_for_file: unused_import

import 'dart:io';

import 'package:elms/controllers/course_material_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/models/quiz.dart';
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
class EditQuiz extends StatefulWidget {
  const EditQuiz({super.key});

  @override
  State<EditQuiz> createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  File? file;
  bool loading = false;
  QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    Quiz? quiz = quizController.selectedQuiz.value;
    TextEditingController titleController =
        TextEditingController(text: quiz?.title);
    TextEditingController deadlineController =
        TextEditingController(text: formDateFormat(quiz!.deadline.toDate()));
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Edit Quiz"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mutedText(text: "Edit quiz details"),
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
                          child: heading("Quiz details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextForm(
                          hint: "Enter title",
                          textEditingController: titleController,
                          label: "Quiz title"),
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
              customButton("Edit quiz", loading: loading, onClick: () {
                if (titleController.text.isEmpty) {
                  Get.snackbar(
                      "Empty field", "Please fill the form to add course");
                } else {
                  setState(() {
                    loading = true;
                  });
                  quizController.updateQuiz({
                    "title": titleController.text,
                    "deadline": DateTime.parse(deadlineController.text)
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Get.back();
                  });
                }
                ;
              }),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  quizController.deleteQuiz().then((value) {
                    Get.back();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading("Delete Quiz", color: Colors.red, fontSize: 14),
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
