
import 'package:elms/controllers/announcements_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/pages/announcements/add_announcement.dart';
import 'package:elms/pages/announcements/edit_announcement.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/format_date.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/muted.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    Get.put(AnnouncementController());
    super.initState();
  }

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: appbar(context, title: "Announcements", actions: [
        GestureDetector(
            onTap: () {
              Get.to(() => const AddAnnouncement());
            },
            child: const Icon(Icons.add)),
        const SizedBox(
          width: 20,
        )
      ]),
      body: GetX<AnnouncementController>(
          init: AnnouncementController(),
          builder: (find) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                      children: find.announcements
                          .map((item) => GestureDetector(
                                onTap: () {
                                  find.selectedAnnouncement.value = item;
                                  Get.to(()=>const EditAnnouncement());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          border: Border.all(color: border)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(child: paragraph(item.title)),
                                                  SizedBox(height: 4,),
                                                                                       mutedText(formatDate(item.createdAt.toDate()))
                                                ],
                                              ),
                                              mutedText(
                                                  item.description)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
                )
              ]),
            );
          }),
    );
  }
}
