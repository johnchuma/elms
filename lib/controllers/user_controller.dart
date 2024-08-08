import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/auth_controlller.dart';
import 'package:elms/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<List<User>> usersReceiver = Rx<List<User>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<User> get users => usersReceiver.value;
  User? selectedUser;
  Rx<User?> loggedInAs = Rx<User?>(null);
  Stream<List<User>> getUsers() {
    return firestore
        .collection("users")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<User> users = [];
      for (var element in querySnapshot.docs) {
        User user = User.fromDocumentSnapshot(element);
        users.add(user);
      }
      return users;
    });
  }

  Future<User?> findUser({email}) async {
    try {
      var userdocuments = await firestore.collection("users").doc(email).get();
      if (userdocuments.exists) {
        return User.fromDocumentSnapshot(userdocuments);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  //find user by registration number
  Future<User?> findUserByUsername({name}) async {
    try {
      var userdocuments = await firestore
          .collection("users")
          .where("name", isEqualTo: name)
          .get();
      if (userdocuments.docs.isNotEmpty) {
        return User.fromDocumentSnapshot(userdocuments.docs.first);
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<void> addUser({name,phone,role, email,password}) async {
    try {
      await firestore.collection("users").doc(email).set({
        "name": name,
        "email": email,
        "phone": phone,
        "role":role??"User",
        "password": password,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(data) async {
    try {
      await firestore.collection("users").doc(selectedUser?.email).update(data);
      AuthController authController = Get.find();
      await authController.user?.updatePassword(data["password"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await firestore.collection("users").doc(selectedUser?.email).delete();
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onInit() {
    usersReceiver.bindStream(getUsers());
    super.onInit();
  }
}
