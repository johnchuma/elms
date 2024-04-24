// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/models/module.dart';
import 'package:get/get.dart';

class ModuleController extends GetxController {
  Rx<List<Module>> modulesReceiver = Rx<List<Module>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Module> get modules => modulesReceiver.value;
  Rx<Module?> selectedModule = Rx<Module?>(null);
  Module? loggedInAs;

  Stream<List<Module>> getModules() {
    return firestore
        .collection("modules")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Module> modules = [];
      for (var element in querySnapshot.docs) {
        Module module = Module.fromDocumentSnapshot(element);
        modules.add(module);
      }
      return modules;
    });
  }

  Future<Module?> findModule({email}) async {
    try {
      var moduledocuments =
          await firestore.collection("modules").doc(email).get();
      if (moduledocuments.exists) {
        return Module.fromDocumentSnapshot(moduledocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addModule({name, code, department}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("modules").doc(id).set({
        "id": id,
        "name": name,
        "code": code,
        "department": department,
        "students": [],
        "teachers": [],
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateModule(data) async {
    try {
      await firestore
          .collection("modules")
          .doc(selectedModule.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteModule() async {
    try {
      await firestore
          .collection("modules")
          .doc(selectedModule.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    modulesReceiver.bindStream(getModules());
    super.onInit();
  }
}
