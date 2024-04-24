import 'package:cloud_firestore/cloud_firestore.dart';

class CourseMaterial {
  late String title;
  late String link;
  late String path;
  late String moduleId;
  late String id;
  late Timestamp createdAt;
  CourseMaterial();
  CourseMaterial.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    title = documentSnapshot["title"];
    path = documentSnapshot["path"];
    moduleId = documentSnapshot["moduleId"];
    link = documentSnapshot["link"];
    createdAt = documentSnapshot["createdAt"];
  }
}
