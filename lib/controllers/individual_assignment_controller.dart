// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/individual_assignment.dart';
import 'package:get/get.dart';

class IndividualAssignmentController extends GetxController {
  Rx<List<IndividualAssignment>> individualassignmentsReceiver =
      Rx<List<IndividualAssignment>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<IndividualAssignment> get individualassignments =>
      individualassignmentsReceiver.value;
  Rx<IndividualAssignment?> selectedIndividualAssignment =
      Rx<IndividualAssignment?>(null);
  IndividualAssignment? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<IndividualAssignment>> getIndividualAssignments() {
    return firestore
        .collection("individualassignments")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<IndividualAssignment> individualassignments = [];
      for (var element in querySnapshot.docs) {
        IndividualAssignment individualassignment =
            IndividualAssignment.fromDocumentSnapshot(element);
        individualassignments.add(individualassignment);
      }
      return individualassignments;
    });
  }

  Future<IndividualAssignment?> findIndividualAssignment({email}) async {
    try {
      var individualassignmentdocuments =
          await firestore.collection("individualassignments").doc(email).get();
      if (individualassignmentdocuments.exists) {
        return IndividualAssignment.fromDocumentSnapshot(
            individualassignmentdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addIndividualAssignment({title, path, date, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("individualassignments").doc(id).set({
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

  Future<void> updateIndividualAssignment(data) async {
    try {
      await firestore
          .collection("individualassignments")
          .doc(selectedIndividualAssignment.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteIndividualAssignment() async {
    try {
      await firestore
          .collection("individualassignments")
          .doc(selectedIndividualAssignment.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    individualassignmentsReceiver.bindStream(getIndividualAssignments());
    super.onInit();
  }
}
