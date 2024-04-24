// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/course_material.dart';

import 'package:get/get.dart';

class CourseMaterialController extends GetxController {
  Rx<List<CourseMaterial>> coursematerialsReceiver =
      Rx<List<CourseMaterial>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<CourseMaterial> get coursematerials => coursematerialsReceiver.value;
  Rx<CourseMaterial?> selectedCourseMaterial = Rx<CourseMaterial?>(null);
  CourseMaterial? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<CourseMaterial>> getCourseMaterials() {
    return firestore
        .collection("coursematerials")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<CourseMaterial> coursematerials = [];
      for (var element in querySnapshot.docs) {
        CourseMaterial coursematerial =
            CourseMaterial.fromDocumentSnapshot(element);
        coursematerials.add(coursematerial);
      }
      return coursematerials;
    });
  }

  Future<CourseMaterial?> findCourseMaterial({email}) async {
    try {
      var coursematerialdocuments =
          await firestore.collection("coursematerials").doc(email).get();
      if (coursematerialdocuments.exists) {
        return CourseMaterial.fromDocumentSnapshot(coursematerialdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addCourseMaterial({title, path, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("coursematerials").doc(id).set({
        "id": id,
        "title": title,
        "path": path,
        "moduleId": moduleController.selectedModule.value?.id,
        "link": link,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCourseMaterial(data) async {
    try {
      await firestore
          .collection("coursematerials")
          .doc(selectedCourseMaterial.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourseMaterial() async {
    try {
      await firestore
          .collection("coursematerials")
          .doc(selectedCourseMaterial.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    coursematerialsReceiver.bindStream(getCourseMaterials());
    super.onInit();
  }
}
