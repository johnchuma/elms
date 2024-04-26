// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elms/controllers/module_controller.dart';
import 'package:elms/models/announcement.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  Rx<List<Announcement>> announcementsReceiver = Rx<List<Announcement>>([]);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Announcement> get announcements => announcementsReceiver.value;
  Rx<Announcement?> selectedAnnouncement = Rx<Announcement?>(null);
  Announcement? loggedInAs;
  ModuleController moduleController = Get.find();

  Stream<List<Announcement>> getAnnouncements() {
    return firestore
        .collection("announcements")
        .where("moduleId",isEqualTo: moduleController.selectedModule.value?.id)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot querySnapshot) async {
      List<Announcement> announcements = [];
      for (var element in querySnapshot.docs) {
        Announcement announcement = Announcement.fromDocumentSnapshot(element);
        announcements.add(announcement);
      }
      return announcements;
    });
  }

  Future<Announcement?> findAnnouncement({email}) async {
    try {
      var announcementdocuments = await firestore.collection("announcements").doc(email).get();
      if (announcementdocuments.exists) {
        return Announcement.fromDocumentSnapshot(announcementdocuments);
      }
      return null;
    } catch (e) {}
    return null;
  }

  Future<void> addAnnouncement({title, description}) async {
    try {
      String id = Timestamp.now().toDate().toString();
      await firestore.collection("announcements").doc(id).set({
        "id": id,
        "title": title,
        "description": description,
        "moduleId": moduleController.selectedModule.value?.id,
        "createdAt": Timestamp.now()
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAnnouncement(data) async {
    try {
      await firestore
          .collection("announcements")
          .doc(selectedAnnouncement.value?.id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAnnouncement() async {
    try {
      await firestore.collection("announcements").doc(selectedAnnouncement.value?.id).delete();
    } catch (e) {}
  }

  @override
  void onInit() {
    announcementsReceiver.bindStream(getAnnouncements());
    super.onInit();
  }
}
