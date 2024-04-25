import 'package:cloud_firestore/cloud_firestore.dart';

class GroupAssignment {
  late String title;
  late String link;
  late Timestamp deadline;
  late List students = [];
  late String path;
  late String moduleId;
  late String id;
  late Timestamp createdAt;
  GroupAssignment();
  GroupAssignment.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    title = documentSnapshot["title"];
    path = documentSnapshot["path"];
    deadline = documentSnapshot["deadline"];
    students = documentSnapshot["students"];
    moduleId = documentSnapshot["moduleId"];
    link = documentSnapshot["link"];
    createdAt = documentSnapshot["createdAt"];
  }
}
