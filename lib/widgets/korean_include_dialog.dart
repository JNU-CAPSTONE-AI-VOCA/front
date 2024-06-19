import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'voca2.dart';

class ExampleDialog extends StatefulWidget {
  String sentence;
  final String fileName;
  final int index;

  ExampleDialog({required this.sentence, required this.fileName, required this.index});

  @override
  _ExampleDialogState createState() => _ExampleDialogState(sentence: sentence, fileName: fileName, index: index);
}

class _ExampleDialogState extends State<ExampleDialog> {
  String sentence;
  final String fileName;
  final int index;

  late Map<String, String> uncompleteJson;
  late String jsonString;
  String korean = '';
  bool _showTranslation = false;

  _ExampleDialogState({required this.sentence, required this.fileName, required this.index});

  void showKorean() async {
    jsonString = jsonEncode({
      'sentence': sentence,
    });
    print('data : ' + jsonString);

    var options = Options(
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    try {
      var data = jsonDecode(jsonString);
      print('Valid JSON: $data');
    } catch (e) {
      print('Invalid JSON: $e');
    }

    var response = await Dio().post(
      'http://13.124.234.107:8080/api/generate/sentence/meaning',
      data: jsonString,
      options: options,
    );
    print(response);
    korean = response.data;
    setState(() {

    });
  }

  void changeSentence() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$fileName.json');
    String jsonContent = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonContent);

    Voca2 v = new Voca2(word: jsonData['words'][index]['word'], meaning: jsonData['words'][index]['meaning']);

    Map<String, dynamic> uncompleteJson = v.toJson();
    String jsonString = jsonEncode({
      'word': uncompleteJson,
    });

    var options = Options(
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    try {
      var data = jsonDecode(jsonString);
      print('Valid JSON: $data');
    } catch (e) {
      print('Invalid JSON: $e');
    }

    var response = await Dio().post(
      'http://13.124.234.107:8080/api/generate/sentence',
      data: jsonString,
      options: options,
    );
    print(response);

    // 문장 변경
    jsonData['words'][index]['sentence'] = response.data;
    print('here');
    print(jsonData['words'][index]['sentence']);
    // 삭제한 단어가 적용되게 해당 단어장 json 파일 덮어쓰기

    final updatedJsonString = json.encode(jsonData);
    print(updatedJsonString);
    await file.writeAsString(updatedJsonString);

    setState(() {
      sentence = response.data;
      _showTranslation = false;
      korean = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('예문'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sentence), // 이 부분을 구현하기 위해
            SizedBox(height: 10),
            if (!_showTranslation)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showTranslation = true; // 버튼을 누르면 상태 변경
                    showKorean();
                    // 해석 함수 호출 -> 응답을 Korean 변수에 저장
                  });
                },
                child: Text('해석 보기'),
              ),
            if (_showTranslation) Text(korean, style: TextStyle(color: Colors.blueGrey),), // Korean 변수 들어갈 자리
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('초기화'),
          onPressed: () {
            changeSentence();
          },
        ),
        ElevatedButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        ),
      ],
    );
  }
}
