import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:windows_app/ui/read_txt.dart';

class ReadDocxFile extends ReadFile {
  @override
  String getFileContent(String path) {
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
}
