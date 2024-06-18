import 'package:elms/controllers/user_controller.dart';
import 'package:get/get.dart';


UserController  userController= Get.find();
String currentUserRol (){
  return userController.loggedInAs.value!.role;
}