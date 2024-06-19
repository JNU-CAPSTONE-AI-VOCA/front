import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temp/voca2.dart';

class SentenceResultStreamWidget extends StatefulWidget {
  final Voca2 answer;
  final String selectedFileName;

  SentenceResultStreamWidget({required this.answer, required this.selectedFileName});

  @override
  _SentenceResultStreamWidgetState createState() => _SentenceResultStreamWidgetState();
}

class _SentenceResultStreamWidgetState extends State<SentenceResultStreamWidget> {

  late Map<String, dynamic> uncompleteJson;
  late List<Map<String, dynamic>> completeJsonList;
  late String jsonString;
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _loadJsonData().then((result) {
      setState(() {
        List<Voca2> completeVocaList = result;

        print("here");
        uncompleteJson = widget.answer.toJson();
        _loadJsonData();
        completeJsonList = completeVocaList.map((e) => e.toJson()).toList();
        jsonString = jsonEncode({
          'incomplete': uncompleteJson,
          'complete': completeJsonList,
        });

        print(jsonString);
        sseConnect();
      });
    });

  }

  Future<List<Voca2>> _loadJsonData() async {
    List<Voca2> completeVocaList = [];
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.selectedFileName}.json');

    if (!file.existsSync()) file.writeAsString('{"words": []}');
    final String jsonString = await file.readAsString();
    List<dynamic> jsonData = await (json.decode(jsonString))['words'];

    for (var data in jsonData) {
        Voca2 v = new Voca2(word: data['word'], meaning: data['mean']);
        completeVocaList.add(v);
    }
    return completeVocaList;
  }

  void sseConnect() async {
    var options = Options(
    contentType: 'application/json',
    responseType: ResponseType.stream,
    );

    try {
      var data = jsonDecode(jsonString);
      print('Valid JSON: $data');
    } catch (e) {
      print('Invalid JSON: $e');
    }

    var response = await Dio().post(
      'http://3.39.139.126:8080/api/generate/sentence/stream',
      data: jsonString,
      options: options,
    );

    response.data.stream.listen((content) {
      setState(() {
        String data = utf8.decode(content);
        if(data != 'data:' && data.trim() != '') {
          resultText += data;
          print(resultText);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Colors.white,
      child: Text(resultText),
    );
  }
}