import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromCamera() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image =
      await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 40);
  return image;
}

Future<XFile?> pickImageFromGalley() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 60);
  return image;
}

Future<PlatformFile?> pickDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'exs'],
  );
  if (result == null) {
    return null;
  }

  return result.files.first;
}
