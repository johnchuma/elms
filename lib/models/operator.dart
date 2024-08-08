import 'package:cloud_firestore/cloud_firestore.dart';

class Operator {
  late String name;
  late String email;
  late String phone;
  late String password;
  late String groupId;
  late String address;
  late String id;
  late Timestamp createdAt;

 
  Operator();
  Operator.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    groupId = documentSnapshot["groupId"];
    address = documentSnapshot["address"];
    phone = documentSnapshot["phone"];
    password = documentSnapshot["password"];
    createdAt = documentSnapshot["createdAt"];
  }
}
