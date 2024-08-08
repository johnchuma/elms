import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/group.dart';
import 'package:elms/pages/change_password.dart';
import 'package:get/get.dart';

class GroupController extends GetxController {
  Rx<List<Group>> groupsReceiver = Rx<List<Group>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Group> get groups => groupsReceiver.value;
  UserController  userController = Get.find();
  Group? selectedGroup;
  Rx<Group?> loggedInAs = Rx<Group?>(null);
  Stream<List<Group>> getGroups() {
    return firestore
        .collection("groups")
        .orderBy("createdAt", descending: true)
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
    Stream<List<Group>> getOperatorGroups() {
    return firestore
        .collection("groups")
        .where("operators", arrayContains: userController.loggedInAs.value?.email)
        .orderBy("createdAt", descending: true)
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
      var groupdocuments =
          await firestore.collection("groups").doc(email).get();
      if (groupdocuments.exists) {
        return Group.fromDocumentSnapshot(groupdocuments);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  //find group by registration number
  Future<Group?> findGroupByReg({reg}) async {
    try {
      var groupdocuments = await firestore
          .collection("groups")
          .where("reg", isEqualTo: reg)
          .get();
      if (groupdocuments.docs.isNotEmpty) {
        return Group.fromDocumentSnapshot(groupdocuments.docs.first);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<void> addGroup({name, address}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("groups").doc(id).set({
        "id": id,
        "name": name,
        "address": address,
        "members": [],
        "operators": [],
        "createdAt": Timestamp.now()
      });
      print("Added successfully");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateGroup(data) async {
    try {
      await firestore.collection("groups").doc(selectedGroup?.id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup() async {
    try {
      await firestore.collection("groups").doc(selectedGroup?.id).delete();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onInit() {
    groupsReceiver.bindStream(userController.loggedInAs.value?.role == "Operator"?getOperatorGroups():getGroups());
    super.onInit();
  }
}
