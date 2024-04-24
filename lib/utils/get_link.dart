// ignore_for_file: body_might_complete_normally_catch_error

import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

Future<String> getLink(var file) async {
  String url = "";
  var fileName = file!.path.split('/').last;
  await storage
      .ref()
      .child("files")
      .child(fileName)
      .putFile(file)
      .catchError((error) {
    return error;
  });
  url = await storage.ref().child("files").child(fileName).getDownloadURL();
  return url;
}
