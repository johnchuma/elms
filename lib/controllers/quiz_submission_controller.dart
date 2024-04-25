// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/quiz_controller.dart';
import 'package:elms/models/submission.dart';
import 'package:get/get.dart';

class QuizSubmissionController extends GetxController {
  Rx<List<Submission>> submissionsReceiver = Rx<List<Submission>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Submission> get submissions => submissionsReceiver.value;
  Rx<Submission?> selectedSubmission = Rx<Submission?>(null);
  QuizController quizController = Get.find();
  Submission? loggedInAs;

  Stream<List<Submission>> getQuizSubmissions() {
    return firestore
        .collection("submissions")
        .where("referenceId", isEqualTo: quizController.selectedQuiz.value?.id)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Submission> submissions = [];
      for (var element in querySnapshot.docs) {
        Submission submission = Submission.fromDocumentSnapshot(element);
        submissions.add(submission);
      }
      return submissions;
    });
  }

  Future<Submission?> findSubmission({email}) async {
    try {
      var submissiondocuments =
          await firestore.collection("submissions").doc(email).get();
      if (submissiondocuments.exists) {
        return Submission.fromDocumentSnapshot(submissiondocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addSubmission({refrenceId, userId, userName, path, link}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("submissions").doc(id).set({
        "id": id,
        "referenceId": refrenceId,
        "marks": 0.0,
        "userName": userName,
        "userId": userId,
        "path": path,
        "link": link,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSubmission(id, data) async {
    try {
      await firestore.collection("submissions").doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubmission() async {
    try {
      await firestore
          .collection("submissions")
          .doc(selectedSubmission.value?.id)
          .delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    submissionsReceiver.bindStream(getQuizSubmissions());
    super.onInit();
  }
}
