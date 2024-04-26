// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/message.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  Rx<List<Message>> messagesReceiver = Rx<List<Message>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Message> get messages => messagesReceiver.value;
  Rx<Message?> selectedMessage = Rx<Message?>(null);
  Message? loggedInAs;
  ModuleController moduleController = Get.find();
 GroupController groupController = Get.find();
  Stream<List<Message>> getMessages() {
    return firestore
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .where("moduleId",isEqualTo: moduleController.selectedModule.value?.id)
        .where("groupId",isEqualTo: groupController.selectedGroup.value?.id)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Message> messages = [];
      for (var element in querySnapshot.docs) {
        Message message = Message.fromDocumentSnapshot(element);
        messages.add(message);
      }
      return messages;
    });
  }

  Future<Message?> findMessage({email}) async {
    try {
      var messagedocuments = await firestore.collection("messages").doc(email).get();
      if (messagedocuments.exists) {
        return Message.fromDocumentSnapshot(messagedocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addMessage({message}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("messages").doc(id).set({
        "id": id,
        "message": message,
        "groupId": groupController.selectedGroup.value?.id,
        "moduleId": moduleController.selectedModule.value?.id,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMessage(data) async {
    try {
      await firestore
          .collection("messages")
          .doc(selectedMessage.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMessage() async {
    try {
      await firestore.collection("messages").doc(selectedMessage.value?.id).delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    messagesReceiver.bindStream(getMessages());
    super.onInit();
  }
}
