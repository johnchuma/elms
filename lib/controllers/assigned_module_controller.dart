// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/module.dart';
import 'package:get/get.dart';

class AssignedModuleController extends GetxController {
  Rx<List<Module>> modulesReceiver = Rx<List<Module>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Module> get modules => modulesReceiver.value;
  Rx<Module?> selectedModule = Rx<Module?>(null);
  UserController userController = Get.find();
  Module? loggedInAs;

  Stream<List<Module>> getModules() {
    return firestore
        .collection("modules").
        where("students",arrayContains: userController.loggedInAs?.id)
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
    modulesReceiver.bindStream(getModules());
    super.onInit();
  }
}
