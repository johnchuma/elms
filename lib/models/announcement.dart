import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  late String title;
  late String description;
  late String moduleId;
  late String id;
  late Timestamp createdAt;
  Announcement();
  Announcement.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    title = documentSnapshot["title"];
    description = documentSnapshot["description"];
    moduleId = documentSnapshot["moduleId"];
    createdAt = documentSnapshot["createdAt"];
  }
}
