import 'dart:isolate';

import 'package:windows_app/file_picker_utils.dart';
import 'package:windows_app/models/shingle_result_model.dart';

class ShinglesGenerator {
  static Map<String, List<String>> shingleMap = {};
  static final List<ShingleResult> _results = [];

  static List<ShingleResult> get result => _results;

  static int _shingleLength = 5;

  static void initShingles({int length = 5}) {
    _shingleLength = length;

    shingleMap = {
      for (var e in FilePickerUtils.shingle.keys)
        e: _createShingle(FilePickerUtils.shingle[e] ?? '')
    };
    
    calculateShingle(shingleMap.keys.first);
  }

  static String _removeChar(String input) {
    String commonWordsRegex =
        "( и | но | или | а | однако | зато | либо | если | то | бы | как | тоже | также | чтобы | потому что | поэтому | то есть | я | именно | когда | в | где )";

    RegExp match = RegExp(r'\P{L}+', unicode: true);
    RegExp match2 = RegExp(commonWordsRegex, unicode: true);

    return input.replaceAll(match, ' ').toLowerCase().replaceAll(match2, ' ');
  }

  static List<String> _createShingle(String input) {
    List<String> shinglesList = [];
    String clearChar = _removeChar(input);
    for (int i = 0; i + _shingleLength <= clearChar.split(' ').length; ++i) {
      shinglesList
          .add(clearChar.split(' ').getRange(i, i + _shingleLength).join(' '));
    }

    return shinglesList.toSet().toList();
  }

  static void calculateShingle(String baseShingleName ) {
    //get base shingle entry
    final List<String> baseShingle = shingleMap[baseShingleName] ?? [];
    //remove base shingle
    Map<String, double> eachResult = {};

    int count = 0;

    for (final shingle in shingleMap.entries) {
      if (shingle.key != baseShingleName) {
        for (int i = 0; i <= shingle.value.length ~/ 2; ++i) {
          if (baseShingle.contains(shingle.value[i])) {
            count++;
          }
          if (i != (shingle.value.length ~/ 2) &&
              baseShingle
                  .contains(shingle.value[shingle.value.length - i - 1])) {
            count++;
          }
        }
        eachResult[shingle.key]= double.tryParse(
                  (count / baseShingle.length * 100).toStringAsFixed(2)) ??
              0;
      
        //print(
        //    "Shingle ${shingle.key} $count ${baseShingle.length}  ${(count / baseShingle.length) * 100}");
        count = 0;
      }
    }
    _results
        .add(ShingleResult(baseFileName: baseShingleName, results: eachResult));
  }
 
}
