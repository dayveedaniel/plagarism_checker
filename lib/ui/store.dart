import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:windows_app/file_picker_utils.dart';
import 'package:windows_app/models/shingle_result_model.dart';
import 'package:windows_app/shingle_utils.dart';

class FileStore {
  ValueNotifier<String> fileContent = ValueNotifier('');

  ValueNotifier<bool> hasNotif = ValueNotifier(false);

  ValueNotifier<List<String>> fileNames = ValueNotifier([]);

  ValueNotifier<List<ShingleResult>> result = ValueNotifier([]);

  ValueNotifier<List<List<String>>> cluster = ValueNotifier([]);

  ValueNotifier<double> filterResult = ValueNotifier(0.0);

  double shingleLenght = 5;

  AppState state = AppState.empty;

  Future<void> pickFiles() async {
    try {
      state = AppState.isLoading;
      await FilePickerUtils.pickFiles();
      FilePickerUtils.createHashMap();
      //FilePickerUtils.myIsolateInstance!.kill();
      fileNames.value = FilePickerUtils.shingle.keys.toList();
      fileContent.value = FilePickerUtils.shingle.values.first;
      initShingles();
      result.value = ShinglesGenerator.result;
    } catch (e) {
      state = AppState.error;
      print(e);
    }
  }

  set setShingleLength(double value) => shingleLenght = value;

  void initShingles() {
    if (fileNames.value.isNotEmpty) {
      ShinglesGenerator.initShingles(length: shingleLenght.toInt());
      result.value = ShinglesGenerator.result;
      hasNotif.value = true;
    }
  }

  void setFileContent({required String key}) {
    fileContent.value = FilePickerUtils.shingle[key] ?? '';
    ShinglesGenerator.calculateShingle(key);
    result.value = ShinglesGenerator.result;
    hasNotif.value = true;
  }

  void deleteFile(int index) {
    FilePickerUtils.deleteFile(index);

    ///TODO: Refactor
    fileNames.value = fileNames.value..removeAt(index);
    fileNames.notifyListeners();
  }

  int runAll() {
    ShinglesGenerator.result.clear();
    ShinglesGenerator.shingleMap.forEach((key, value) {
      ShinglesGenerator.calculateShingle(key);
    });
    result.value = ShinglesGenerator.result;
    runCluster();
    hasNotif.value = true;

    return 1;
  }

  void runCluster() {
    String baseFile;
    baseFile = ShinglesGenerator.result.first.baseFileName;

    List<List<String>> similarFile = [];

    List<String> found_matched = [];

    for (var element in ShinglesGenerator.result) {
      baseFile = element.baseFileName;
      if (element.baseFileName == baseFile) {
        found_matched.add(element.baseFileName);
        for (var entry in element.results.entries) {
          if (entry.value >= filterResult.value &&
              findGreater(entry.key, element.baseFileName).isNotEmpty) {
            found_matched.add(entry.key);
          }
        }
      }
      similarFile.add(found_matched);
      found_matched = [];

      if (element.baseFileName != baseFile &&
          element.results[baseFile]! >= filterResult.value) {
        print(" $baseFile  ${element.results[baseFile]}");
      }
    }
    cluster.value = similarFile;
    print(similarFile);
  }

  String findGreater(String key, String find) {
    String foundSimilar = '';
    for (final result in ShinglesGenerator.result) {
      if (result.baseFileName == key &&
          result.results[find]! >= filterResult.value) {
        foundSimilar = result.baseFileName;
      }
    }
    return foundSimilar;
    // ShinglesGenerator.result.forEach((element) { })
  }

  Future<void> createIsolate() async {
    ReceivePort isolateToMain = ReceivePort();

    isolateToMain.listen((data) {
      print(data);
      // Listen for data passed back to the main process
    });

    Isolate myIsolateShingle =
        await Isolate.spawn(myIsolate, isolateToMain.sendPort);
  }

  void myIsolate(SendPort mainToIsolate) {
    mainToIsolate.send(runAll());
  }

  void deleteResult(int index) {
    ///TODO: Refactor

    result.value = ShinglesGenerator.result..removeAt(index);
    result.notifyListeners();
  }
}

enum AppState { loaded, isLoading, empty, error }
