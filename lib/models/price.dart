import 'package:cloud_firestore/cloud_firestore.dart';

class Price{
  late double price;
  Price();
  Price.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    price = documentSnapshot["price"];
  }
}