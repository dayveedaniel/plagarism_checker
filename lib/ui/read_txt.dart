import 'dart:io';

class ReadTxtFile extends ReadFile {
  @override
  String getFileContent(String path) {
    return File(path).readAsStringSync();
  }
}

class ReadPdfFile extends ReadFile {
  @override
  String getFileContent(String path) {
    return File(path).readAsStringSync();
  }
}

abstract class ReadFile {
  String getFileContent(String path);
}
