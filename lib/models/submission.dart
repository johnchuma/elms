import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  late String userName;
  late String userId;
  late String referenceId;
  late String link;
  late double marks = 0;
  late String path;
  late String id;
  late Timestamp createdAt;
  Submission();
  Submission.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    path = documentSnapshot["path"];
    link = documentSnapshot["link"];
    marks = double.parse(documentSnapshot["marks"].toString());
    userName = documentSnapshot["userName"];
    userId = documentSnapshot["userId"];
    referenceId = documentSnapshot["referenceId"];
    createdAt = documentSnapshot["createdAt"];
  }
}
