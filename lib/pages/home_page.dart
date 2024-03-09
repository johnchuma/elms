// ignore_for_file: avoid_unnecessary_containers

import 'package:elms/pages/module_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/drawer.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../widgets/heading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      drawer: Drawer(
        child: drawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: heading("Dashboard"),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                mutedText("2015/2020", fontWeight: FontWeight.bold),
                const SizedBox(
                  width: 15,
                ),
                mutedText("BENG ETE")
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20),
                  children: ["ETE 23093", "COU 34892", "ME 12342", "COU 24321"]
                      .map((item) => GestureDetector(
                            onTap: () {
                              Get.to(() => const ModulePage());
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: AppColors.primaryColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    paragraph(item, color: Colors.white),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      OctIcons.graph,
                                      size: 45,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            )
          ]),
        ),
      ),
    );
  }
}
