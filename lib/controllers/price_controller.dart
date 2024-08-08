import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/price.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class PriceController extends GetxController {
  Rx<List<Price>> pricesReceiver = Rx<List<Price>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Price> get prices => pricesReceiver.value;
  Price? selectedPrice;
  Rx<Price?> loggedInAs = Rx<Price?>(null);
  BluetoothConnection? bluetoothConnection;
  UserController userController = Get.find();

  Stream<List<Price>> getPrices() {
    return firestore
        .collection("prices")
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Price> prices = [];
      for (var element in querySnapshot.docs) {
        Price price = Price.fromDocumentSnapshot(element);
        prices.add(price);
      }
      return prices;
    });
  }

  Future<void> addPrice({price}) async {
    try {
      String id = "price";
      await firestore.collection("prices").doc(id).set({
        "id": id,
        "price": price
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void onInit() {
    pricesReceiver.bindStream(getPrices());
    super.onInit();
  }
}
