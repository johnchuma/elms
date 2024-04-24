import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  late String name;
  late String code;
  late String department;
  late String id;
  late Timestamp createdAt;
  late List students = [];
  late List teachers = [];
  Module();
  Module.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    code = documentSnapshot["code"];
    department = documentSnapshot["department"];
    createdAt = documentSnapshot["createdAt"];
    students = documentSnapshot["students"];
    teachers = documentSnapshot["teachers"];
  }
}
