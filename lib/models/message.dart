import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String message;
  late String groupId;
  late String moduleId;
  late String id;
  late Timestamp createdAt;
  Message();
  Message.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    moduleId = documentSnapshot["moduleId"];
    groupId = documentSnapshot["groupId"];
    message = documentSnapshot["message"];
    createdAt = documentSnapshot["createdAt"];
  }
}
