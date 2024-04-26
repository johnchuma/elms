// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/group.dart';

import 'package:get/get.dart';

class GroupController extends GetxController {
  Rx<List<Group>> groupsReceiver = Rx<List<Group>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Group> get groups => groupsReceiver.value;
  Rx<Group?> selectedGroup = Rx<Group?>(null);
  Group? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<Group>> getGroups() {
    return firestore
        .collection("groups")
        .orderBy("createdAt", descending: true)
        .where("moduleId",isEqualTo: moduleController.selectedModule.value?.id)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Group> groups = [];
      for (var element in querySnapshot.docs) {
        Group group = Group.fromDocumentSnapshot(element);
        groups.add(group);
      }
      return groups;
    });
  }

  Future<Group?> findGroup({email}) async {
    try {
      var groupdocuments = await firestore.collection("groups").doc(email).get();
      if (groupdocuments.exists) {
        return Group.fromDocumentSnapshot(groupdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addGroup({name}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("groups").doc(id).set({
        "id": id,
        "name": name,
        "students": [],
        "moduleId": moduleController.selectedModule.value?.id,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGroup(data) async {
    try {
      await firestore
          .collection("groups")
          .doc(selectedGroup.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup() async {
    try {
      await firestore.collection("groups").doc(selectedGroup.value?.id).delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    groupsReceiver.bindStream(getGroups());
    super.onInit();
  }
}
