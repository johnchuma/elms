// ignore_for_file: unused_import

import 'package:elms/pages/assesment_center.dart';
import 'package:elms/widgets/default_appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  String selectedItem = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: defaultAppbar("Tutorials"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
                children: [
              {
                "title": "Introduction to programming",
                "description":
                    "Here is the descriptla do enim in sint incididunt ad duis consectetur.",
                "page": Container()
              },
              {
                "title": "Computer hardware design",
                "description":
                    "Here is the description Ea quis do ad elit consectetur voluptate do enim. Enim qui t.",
                "page": Container()
              },
              {
                "title": "Arduino and At-Mega master course",
                "description":
                    "Here is the description Nostrud consectetur voluptate amet Lorem non sit tempor aliqua eu ",
                "page": const AssesmentCenter()
              }
            ]
                    .map((item) => GestureDetector(
                          onTap: () {
                            if (selectedItem != item["title"]) {
                              setState(() {
                                selectedItem = item["title"].toString();
                              });
                            } else {
                              setState(() {
                                selectedItem = "";
                              });
                            }
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
                                          child: Image.asset("assets/doc.png")),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            paragraph(item["title"],
                                                maxLines: 1),
                                            mutedText(item["description"],
                                                maxLines: selectedItem ==
                                                        item["title"]
                                                    ? 50
                                                    : 2),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            if (selectedItem == item["title"])
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  heading("View",
                                                      color: Colors.green,
                                                      fontSize: 16),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  heading("Download",
                                                      color: Colors.orange,
                                                      fontSize: 16),
                                                ],
                                              ),
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
