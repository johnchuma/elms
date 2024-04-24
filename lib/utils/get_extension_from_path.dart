String getExtensionFromPath(String path) {
  String icon = "";
  switch (path.split('.').last) {
    case "pdf":
      icon = "assets/pdf.png";
      break;
    case "docx":
      icon = "assets/doc.png";
      break;
    case "doc":
      icon = "assets/doc.png";
      break;
    case "ppt":
      icon = "assets/ppt.png";
      break;
    default:
  }
  return icon;
}
