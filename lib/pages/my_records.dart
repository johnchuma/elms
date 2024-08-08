

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/record_controller.dart';
import 'package:elms/models/record.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/utils/colors.dart';
import 'package:elms/utils/time_ago.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class MyRecords extends StatefulWidget {
  const MyRecords({Key? key}) : super(key: key);

  @override
  State<MyRecords> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  @override
  void initState() {
    // Get.put(RecordController());
    super.initState();
  }

  var category = "All".obs;
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    var role = userController.loggedInAs.value?.role;
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(context, title: "Previous Records", actions: [
        if (role == "Operator")
          GestureDetector(
              onTap: () {
                // Get.to(() => const AddRecord());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        const SizedBox(
          width: 20,
        )
      ]),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:StreamBuilder(
              stream: FirebaseFirestore.instance.collection("records").where("farmerId",isEqualTo: userController.loggedInAs.value?.email).snapshots(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }
                List<Record> records  = [];
              var data = snapshot.requireData;
              for (var element in data.docs) {
                records.add(Record.fromDocumentSnapshot(element));
              }

                return records.isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.only(top: 20),
                        children: records.map((item) {
                          return GestureDetector(
                            onTap: () {
                            
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(color: border)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          color: Colors.orange.withOpacity(0.1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.history,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            heading("${item.weight} KG",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            mutedText(
                                                text: timeAgo(
                                                    item.createdAt.toDate()))
                                          ],
                                        ),
                                      
                                      ),
                                      mutedText(text: "${item.price} TSH")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help,
                            size: 100,
                            color: AppColors.primaryColor,
                          ),
                          heading(
                              "No data available, Data will be displayed here",
                              color: Color.fromARGB(255, 180, 182, 181),
                              textAlign: TextAlign.center),
                        ],
                      );
              })),
    );
  }
}
