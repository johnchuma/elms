import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late String phone;
  late String email;
  late String role;
  late String password;
  late String reg;
  late String department;
  late String id;
  late Timestamp createdAt;
  User.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot["name"];
    phone = documentSnapshot["phone"];
    email = documentSnapshot["email"];
    role = documentSnapshot["role"];
    password = documentSnapshot["password"];
    reg = documentSnapshot["reg"];
    department = documentSnapshot["department"];
    id = documentSnapshot["id"];
    createdAt = documentSnapshot["createdAt"];
  }
}
