// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/tutorial.dart';

import 'package:get/get.dart';

class TutorialController extends GetxController {
  Rx<List<Tutorial>> tutorialsReceiver = Rx<List<Tutorial>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Tutorial> get tutorials => tutorialsReceiver.value;
  Rx<Tutorial?> selectedTutorial = Rx<Tutorial?>(null);
  Tutorial? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<Tutorial>> getTutorials() {
    return firestore
        .collection("tutorials")
        .where("moduleId",isEqualTo: moduleController.selectedModule.value?.id)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Tutorial> tutorials = [];
      for (var element in querySnapshot.docs) {
        Tutorial tutorial = Tutorial.fromDocumentSnapshot(element);
        tutorials.add(tutorial);
      }
      return tutorials;
    });
  }

  Future<Tutorial?> findTutorial({email}) async {
    try {
      var tutorialdocuments =
          await firestore.collection("tutorials").doc(email).get();
      if (tutorialdocuments.exists) {
        return Tutorial.fromDocumentSnapshot(tutorialdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addTutorial({title, introduction, path, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("tutorials").doc(id).set({
        "id": id,
        "title": title,
        "introduction": introduction,
        "path": path,
        "moduleId": moduleController.selectedModule.value?.id,
        "link": link,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTutorial(data) async {
    try {
      await firestore
          .collection("tutorials")
          .doc(selectedTutorial.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTutorial() async {
    try {
      await firestore
          .collection("tutorials")
          .doc(selectedTutorial.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    tutorialsReceiver.bindStream(getTutorials());
    super.onInit();
  }
}
