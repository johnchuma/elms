// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/module.dart';
import 'package:get/get.dart';

class AssignedModuleController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<List<Module>> studentModulesReceiver = Rx<List<Module>>([]);
  List<Module> get studentsModules => studentModulesReceiver.value;
  Rx<List<Module>> teachersModulesReceiver = Rx<List<Module>>([]);
  List<Module> get teachersModules => teachersModulesReceiver.value;
  Rx<Module?> selectedModule = Rx<Module?>(null);
  UserController userController = Get.find();
  Module? loggedInAs;

  Stream<List<Module>> getModulesAsTeacher() {
    return firestore
        .collection("modules")
        .where("teachers",arrayContains: userController.loggedInAs.value?.id)
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

  Stream<List<Module>> getModulesAsStudent() {
    return firestore
        .collection("modules")
        .where("students",arrayContains: userController.loggedInAs.value?.id)
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

  @override
  void onInit() {
    studentModulesReceiver.bindStream(getModulesAsStudent());
    teachersModulesReceiver.bindStream(getModulesAsTeacher());
    super.onInit();
  }
}
