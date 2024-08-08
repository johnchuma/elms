import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  late String name;
  late String address;
  late List members = [];
  late List operators = [];
  late String id;
  late Timestamp createdAt;

 
  Group();
  Group.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    address = documentSnapshot["address"];
    members = documentSnapshot["members"];
    operators = documentSnapshot["operators"];
    createdAt = documentSnapshot["createdAt"];
  }
}
