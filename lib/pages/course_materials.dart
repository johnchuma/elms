// ignore_for_file: sized_box_for_whitespace

import 'package:elms/pages/assesment_center.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseMaterials extends StatelessWidget {
  const CourseMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("Course materials"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
                children: [
              {"title": "Introduction to programming", "page": Container()},
              {"title": "Computer hardware design", "page": Container()},
              {
                "title": "Arduino and At-Mega master course",
                "page": const AssesmentCenter()
              }
            ]
                    .map((item) => GestureDetector(
                          onTap: () {
                            Get.to(
                                () => Container(child: item["page"] as Widget));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 30,
                                          child: Image.asset("assets/ppt.png")),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            paragraph(item["title"]),
                                            mutedText("Uploaded 2 days ago")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList()),
          )
        ]),
      ),
    );
  }
}
