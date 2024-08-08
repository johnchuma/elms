import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late String email;
  late String password;
  late String role;
  late Timestamp createdAt;
  User.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    password = documentSnapshot["password"];
    role = documentSnapshot["role"];
    createdAt = documentSnapshot["createdAt"];
  }
}
