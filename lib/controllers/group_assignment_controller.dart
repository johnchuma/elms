// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/group_assignment.dart';
import 'package:get/get.dart';

class GroupAssignmentController extends GetxController {
  Rx<List<GroupAssignment>> groupassignmentsReceiver =
      Rx<List<GroupAssignment>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<GroupAssignment> get groupassignments => groupassignmentsReceiver.value;
  Rx<GroupAssignment?> selectedGroupAssignment = Rx<GroupAssignment?>(null);
  GroupAssignment? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<GroupAssignment>> getGroupAssignments() {
    return firestore
        .collection("groupassignments")
        .where("moduleId",isEqualTo: moduleController.selectedModule.value?.id)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<GroupAssignment> groupassignments = [];
      for (var element in querySnapshot.docs) {
        GroupAssignment groupassignment =
            GroupAssignment.fromDocumentSnapshot(element);
        groupassignments.add(groupassignment);
      }
      return groupassignments;
    });
  }

  Future<GroupAssignment?> findGroupAssignment({email}) async {
    try {
      var groupassignmentdocuments =
          await firestore.collection("groupassignments").doc(email).get();
      if (groupassignmentdocuments.exists) {
        return GroupAssignment.fromDocumentSnapshot(groupassignmentdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addGroupAssignment({title, path, date, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("groupassignments").doc(id).set({
        "id": id,
        "title": title,
        "path": path,
        "students": [],
        "deadline": Timestamp.fromDate(date),
        "moduleId": moduleController.selectedModule.value?.id,
        "link": link,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGroupAssignment(data) async {
    try {
      await firestore
          .collection("groupassignments")
          .doc(selectedGroupAssignment.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroupAssignment() async {
    try {
      await firestore
          .collection("groupassignments")
          .doc(selectedGroupAssignment.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    groupassignmentsReceiver.bindStream(getGroupAssignments());
    super.onInit();
  }
}
