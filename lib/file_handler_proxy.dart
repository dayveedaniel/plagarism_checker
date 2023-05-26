import 'package:windows_app/file_picker_utils.dart';
import 'package:windows_app/shingle_utils.dart';

import 'models/shingle_result_model.dart';

class FileHandlerProxy implements FileHandler {
  Map<String, List<String>> shingleMapCache = {};
  bool shingleUpdated = false;

  List<ShingleResult> result = [];

  @override
  void initShinglesMap({int length = 5}) {
    if (FileRepository.isFilesEdited) {
      shingleMapCache.clear();
      FileHandler.initShingles(length: length);
      shingleUpdated = true;
      shingleMapCache = FileHandler.shingleMap;
      return;
    }
  }

  @override
  void calculateResult(String baseShingleName) {
    if (FileRepository.isFilesEdited) {
      result.clear();
      FileHandler.calculateShingle(baseShingleName);
      result = FileHandler.result;
      return;
    }
  }
}
