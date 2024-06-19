import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'voca2.dart';

class Result5ItemsWidget extends StatefulWidget {
  final Voca2 answer;
  final ValueChanged<bool> onItemSelected; // 콜백 함수 추가

  Result5ItemsWidget({required this.answer, required this.onItemSelected});

  @override
  _Result5ItemsWidgetState createState() => _Result5ItemsWidgetState();
}

class _Result5ItemsWidgetState extends State<Result5ItemsWidget> {

  late Map<String, dynamic> uncompleteJson;
  late String jsonString;
  String resultText = '';

  // 리스트에 표시할 항목
  List<String> items = [];
  // 현재 선택된 라디오 버튼의 인덱스를 저장할 변수
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
      setState(() {
        print("here");
        uncompleteJson = widget.answer.toJson();
        jsonString = jsonEncode({
          'word': uncompleteJson,
        });
        print('data : ' + jsonString);
        Connect();
      });
  }

  void Connect() async {
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
      'http://13.124.234.107:8080/api/generate/words',
      data: jsonString,
      options: options,
    );

    print(response.data);
    setState(() {
      items = response.data.split(', ');
    });

    // 결과 출력
    for (var item in items) {
      print(item);
      print(widget.answer.word);
      if (item == widget.answer.word) {
        print('!!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;

        return RadioListTile<int>(
          value: index,
          groupValue: _selectedIndex,
          title: Text(item),
          onChanged: (int? value) {
            setState(() {
              _selectedIndex = value;
              widget.onItemSelected(item == widget.answer.word);
            });
          },
          secondary: Text(''),
        );
      }).toList(),
    );
  }
}