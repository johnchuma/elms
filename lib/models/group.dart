import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  late String name;
  late List students = [];
  late String moduleId;
  late String id;
  late Timestamp createdAt;
  Group();
  Group.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    students = documentSnapshot["students"];
    moduleId = documentSnapshot["moduleId"];
    createdAt = documentSnapshot["createdAt"];
  }
}
