import 'package:cloud_firestore/cloud_firestore.dart';

class Record{
  late String id;
  late String farmerId;
  late double weight;
  late double price;
  late Timestamp createdAt;
  Record();
  Record.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    farmerId = documentSnapshot["farmerId"];
    weight = documentSnapshot["weight"];
    price = documentSnapshot["price"];
    createdAt = documentSnapshot["createdAt"];
    id = documentSnapshot["id"];
  }
}