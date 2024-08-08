import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/farmer.dart';
import 'package:get/get.dart';

class FarmerController extends GetxController {
  Rx<List<Farmer>> farmersReceiver = Rx<List<Farmer>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Farmer> get farmers => farmersReceiver.value;
  Farmer? selectedFarmer;
  Rx<Farmer?> loggedInAs = Rx<Farmer?>(null);
  GroupController groupController = Get.find();
  UserController userController = Get.find();

  Stream<List<Farmer>> getFarmers() {
    return firestore
        .collection("farmers")
        .orderBy("createdAt", descending: true)
        .where("groupId", isEqualTo: groupController.selectedGroup?.id)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Farmer> farmers = [];
      for (var element in querySnapshot.docs) {
        Farmer farmer = Farmer.fromDocumentSnapshot(element);
        farmers.add(farmer);
      }
      return farmers;
    });
  }

  Future<Farmer?> findFarmer({email}) async {
    try {
      var farmerdocuments =
          await firestore.collection("farmers").doc(email).get();
      if (farmerdocuments.exists) {
        return Farmer.fromDocumentSnapshot(farmerdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  //find farmer by registration number
  Future<Farmer?> findFarmerByReg({reg}) async {
    try {
      var farmerdocuments = await firestore
          .collection("farmers")
          .where("reg", isEqualTo: reg)
          .get();
      if (farmerdocuments.docs.isNotEmpty) {
        return Farmer.fromDocumentSnapshot(farmerdocuments.docs.first);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<void> addFarmer({name, email, phone, password, address}) async {
    try {
      String id = email;
      var currentLoggedInUser = userController.loggedInAs.value;

      await firestore.collection("farmers").doc(id).set({
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "groupId": groupController.selectedGroup?.id,
        "address": groupController.selectedGroup?.address,
        "password": password,
        "createdAt": Timestamp.now()
      });
      await groupController.updateGroup({
        "members": FieldValue.arrayUnion([id])
      });
      await AuthController()
          .auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await AuthController().auth.signOut();
      await AuthController().auth.signInWithEmailAndPassword(
          email: currentLoggedInUser!.email,
          password: currentLoggedInUser.password);
      await UserController().addUser(
          name: name,
          phone: phone,
          email: email,
          password: password,
          role: "Farmer");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateFarmer(data) async {
    try {
      await firestore
          .collection("farmers")
          .doc(selectedFarmer?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFarmer() async {
    try {
      await firestore.collection("farmers").doc(selectedFarmer?.id).delete();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onInit() {
    farmersReceiver.bindStream(getFarmers());
    super.onInit();
  }
}
