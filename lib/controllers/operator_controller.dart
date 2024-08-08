import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/controllers/group_controller.dart';
import 'package:elms/controllers/user_controller.dart';
import 'package:elms/models/operator.dart';
import 'package:get/get.dart';

class OperatorController extends GetxController {
  Rx<List<Operator>> operatorsReceiver = Rx<List<Operator>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Operator> get operators => operatorsReceiver.value;
  UserController userController = Get.find();
  Operator? selectedOperator;
  Rx<Operator?> loggedInAs = Rx<Operator?>(null);
  GroupController groupController = Get.find();
  Stream<List<Operator>> getOperators() {
    return firestore
        .collection("operators")
        .orderBy("createdAt", descending: true)
        .where("groupId", isEqualTo: groupController.selectedGroup?.id)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Operator> operators = [];
      for (var element in querySnapshot.docs) {
        Operator operator = Operator.fromDocumentSnapshot(element);
        operators.add(operator);
      }
      return operators;
    });
  }

  Future<Operator?> findOperator({email}) async {
    try {
      var operatordocuments =
          await firestore.collection("operators").doc(email).get();
      if (operatordocuments.exists) {
        return Operator.fromDocumentSnapshot(operatordocuments);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  //find operator by registration number
  Future<Operator?> findOperatorByReg({reg}) async {
    try {
      var operatordocuments = await firestore
          .collection("operators")
          .where("reg", isEqualTo: reg)
          .get();
      if (operatordocuments.docs.isNotEmpty) {
        return Operator.fromDocumentSnapshot(operatordocuments.docs.first);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<void> addOperator({name, email, phone, password, address}) async {
    try {
      String id = email;
      var currentLoggedInUser = userController.loggedInAs.value;

      await firestore.collection("operators").doc(id).set({
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
        "operators": FieldValue.arrayUnion([id])
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
          role: "Operator");
      print("Added successfully");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateOperator(data) async {
    try {
      await firestore
          .collection("operators")
          .doc(selectedOperator?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOperator() async {
    try {
      await firestore
          .collection("operators")
          .doc(selectedOperator?.id)
          .delete();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onInit() {
    operatorsReceiver.bindStream(getOperators());
    super.onInit();
  }
}
