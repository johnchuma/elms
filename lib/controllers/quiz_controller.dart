// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/quiz.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  Rx<List<Quiz>> quizesReceiver = Rx<List<Quiz>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Quiz> get quizes => quizesReceiver.value;
  Rx<Quiz?> selectedQuiz = Rx<Quiz?>(null);
  Quiz? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<Quiz>> getQuizes() {
    return firestore
        .collection("quizes")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Quiz> quizes = [];
      for (var element in querySnapshot.docs) {
        Quiz quiz = Quiz.fromDocumentSnapshot(element);
        quizes.add(quiz);
      }
      return quizes;
    });
  }

  Future<Quiz?> findQuiz({email}) async {
    try {
      var quizdocuments = await firestore.collection("quizes").doc(email).get();
      if (quizdocuments.exists) {
        return Quiz.fromDocumentSnapshot(quizdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addQuiz({title, path, date, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("quizes").doc(id).set({
        "id": id,
        "title": title,
        "path": path,
        "students": [],
        "deadline": Timestamp.fromDate(date),
        "moduleId": moduleController.selectedModule.value?.id,
        "link": link,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuiz(data) async {
    try {
      await firestore
          .collection("quizes")
          .doc(selectedQuiz.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuiz() async {
    try {
      await firestore.collection("quizes").doc(selectedQuiz.value?.id).delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    quizesReceiver.bindStream(getQuizes());
    super.onInit();
  }
}
