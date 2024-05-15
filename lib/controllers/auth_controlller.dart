import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<User?> usersController = Rx<User?>(null);
  User? get user => usersController.value;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    usersController.bindStream(auth.authStateChanges());
    super.onInit();
  }
}