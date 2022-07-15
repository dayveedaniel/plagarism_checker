import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  static final Set<PlatformFile> _files = {};

  static Isolate? myIsolateInstance;

  // static String getFileContent(int index) => filesContent.elementAt(index);

  static Map<String, String> shingle = {};

  static Map<String, String> createHashMap() {
    //change to add if absent
    for (final file in _files) {
      shingle[file.name] = _readFileContent(file);
    }
    return shingle;
  }

  static Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'txt', 'docx'],
    );

    if (result != null) {
      _files.addAll(result.files);
    } else {
      print("result");
      // User canceled the picker
    }
  }

  static String _readFileContent(PlatformFile file) {
    switch (file.extension) {
      case 'txt':
        return File(file.path ?? '').readAsStringSync();
      //fileContent.value = createShingle( removeChar(File(chosenFile.path ?? '').readAsStringSync())).toString();
      case 'pdf':
        return _getStringFromDocx(file.path ?? '');
      default:
        return _getStringFromDocx(file.path ?? '');
    }
  }

  static String _getStringFromDocx(String path) {
    final RegExp matchFile2 = RegExp(r'(?<=>)([^<>]+)(?=<\/w:t>)');
    final fie = File(path).readAsBytesSync();
    String ans = '';

    Archive archive = ZipDecoder().decodeBytes(fie);
    for (final file in archive) {
      if (file.isFile && file.name.contains('word/document.xml')) {
        final xmlContent = utf8.decode(file.content);

        ans = xmlContent.splitMapJoin(matchFile2,
            onMatch: (match) {
              return match[0] ?? '';
            },
            onNonMatch: (n) => ' ');
      }
      //  else {
      //   print('error');
      //   //Directory(decodePath)..create(recursive: true);
      // }
    }
    return ans;
  }

  static void deleteFile(int index) {
    shingle.remove(_files.elementAt(index).name);
    _files.remove(_files.elementAt(index));
  }

  // main process

  static Future<void> createIsolate() async {
    ReceivePort isolateToMain = ReceivePort();
    myIsolateInstance = await Isolate.spawn(myIsolate, isolateToMain.sendPort);

    isolateToMain.listen((data) {
      print(data);

      // Listen for data passed back to the main process
    });
  }

// isolate process

  static void myIsolate(SendPort mainToIsolate) {
    mainToIsolate.send(createHashMap());
  }
}
