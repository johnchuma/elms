import 'package:elms/pages/assesment_center.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndividualAssignments extends StatelessWidget {
  const IndividualAssignments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("Individual assignments"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
                children: [
              {"title": "Assignment 1", "page": Container()},
              {"title": "Assignment 2", "page": Container()},
              {"title": "Assignment 3", "page": const AssesmentCenter()}
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
                                      SizedBox(
                                          height: 30,
                                          child: Image.asset("assets/pdf.png")),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            paragraph(item["title"]),
                                            mutedText("deadline 12/4/2024")
                                          ],
                                        ),
                                      ),
                                      if (item["title"] == "Assignment 1")
                                        Container(
                                          child: heading("Not submitted",
                                              color: Colors.red, fontSize: 11),
                                        ),
                                      if (item["title"] != "Assignment 1")
                                        Container(
                                          child: heading("Submitted",
                                              color: Colors.green,
                                              fontSize: 11),
                                        )
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
