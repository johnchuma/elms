import 'package:elms/pages/home_page.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

Widget drawer() {
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Container(
          color: AppColors.primaryColor,
          width: double.infinity,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SizedBox(height: 70, child: Image.asset("assets/dit.png")),
                const SizedBox(width: 10),
                heading("DIT|e-LMS", color: Colors.white)
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
              children: [
            {
              "title": "Dashboard",
              "iconData": OctIcons.home,
              "page": const HomePage()
            },
            {
              "title": "Curriculum",
              "iconData": OctIcons.file,
              "page": Container()
            },
            {
              "title": "Carry",
              "iconData": OctIcons.archive,
              "page": Container()
            }
          ].map((item) {
            return GestureDetector(
              onTap: () {
                Get.to(() => item["page"] as Widget);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(
                              item["iconData"] as IconData,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            paragraph(item["title"],
                                color: Colors.black87,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
        )
      ],
    ),
  );
}
