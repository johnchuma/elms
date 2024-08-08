// ignore_for_file: unused_import

import 'dart:math';

import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController nameController = TextEditingController();

  TextEditingController addressController = TextEditingController(text: "Select address");
  List<String> roles = ["Select address", "Dar es salaam", "Dodoma", "Iringa","Mbeya","Mwanza","Arusha","Kilimanjaro","Tanga","Morogoro","Kigoma","Ruvuma","Singida","Tabora","Shinyanga","Manyara","Lindi","Mara","Pwani","Katavi","Geita","Simiyu","Njombe","Kagera","Zanzibar","Kusini Pemba","Kaskazini Pemba","Kusini Unguja","Kaskazini Unguja"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "New Group"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              mutedText(text: "Fill group's details below"),
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
                          child: heading("Group's details", color: Colors.white)),
                      const SizedBox(
                        height: 10,
                      ),
                        
                      TextForm(
                          hint: "Enter a name",
                          textEditingController: nameController,
                          label: "Group Name"),
                
                    
                          selectForm(
                          onChanged: () {
                            setState(() {});
                          },
                          items: roles
                              .map((e) => 
                              DropdownMenuItem(
                                    value: e,
                                    child: paragraph(e),
                                  ))
                              .toList(),
                          textEditingController: addressController,
                          label: "Address"),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customButton("Add Group",
                  onClick: () => {
                        if (nameController.text.isEmpty ||
                            addressController.text.isEmpty)
                          {
                            Get.snackbar("Empty field",
                                "Please fill the form to add expense")
                          }
                        else
                          {
                            print("Adding"),
                            GroupController().addGroup(
                              name: nameController.text,
                              address: addressController.text,
                            ).then((res){
                              Get.back();
                              Get.snackbar("Success", "Group added successfully");
                            }),
                          }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
