import 'package:cloud_firestore/cloud_firestore.dart';

class Tutorial {
  late String title;
  late String link;
  late String path;
  late String introduction;

  late String moduleId;
  late String id;
  late Timestamp createdAt;
  Tutorial();
  Tutorial.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    title = documentSnapshot["title"];
    introduction = documentSnapshot["introduction"];
    path = documentSnapshot["path"];
    moduleId = documentSnapshot["moduleId"];
    link = documentSnapshot["link"];
    createdAt = documentSnapshot["createdAt"];
  }
}
