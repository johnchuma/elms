import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/farmer_controller.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/record.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  Rx<List<Record>> recordsReceiver = Rx<List<Record>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Record> get records => recordsReceiver.value;
  Record? selectedRecord;
  Rx<Record?> loggedInAs = Rx<Record?>(null);
  FarmerController farmerController = Get.find();
  BluetoothConnection? bluetoothConnection;
  
  UserController userController = Get.find();

  Stream<List<Record>> getRecords() {
    return firestore
        .collection("records")
        .orderBy("createdAt", descending: true)
        .where("farmerId", isEqualTo: farmerController.selectedFarmer?.id)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Record> records = [];
      for (var element in querySnapshot.docs) {
        Record record = Record.fromDocumentSnapshot(element);
        records.add(record);
      }
      return records;
    });
  }



  

  Future<void> addRecord({ weight,price}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("records").doc(id).set({
        "id": id,
        "weight": weight,
        "price": price,
        "farmerId": farmerController.selectedFarmer?.id,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateRecord(data) async {
    try {
      await firestore
          .collection("records")
          .doc(selectedRecord?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRecord() async {
    try {
      await firestore.collection("records").doc(selectedRecord?.id).delete();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onInit() {
    recordsReceiver.bindStream(getRecords());
    super.onInit();
  }
}
