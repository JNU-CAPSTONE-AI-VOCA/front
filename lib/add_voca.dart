import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'widgets/my_bottom_bar.dart';
import 'voca.dart';

var backColor = Color(0xffeeebeb);

class AddVoca extends StatefulWidget {
  String fileName = '';

  AddVoca({Key? key, required this.fileName}) : super(key: key);
  @override
  _AddVoca createState() => _AddVoca(selectedFileName: fileName);
}

class _AddVoca extends State<AddVoca> {
  String selectedFileName = '';

  String word = '';
  String mean = '';
  String sentence = '';
  TextEditingController _WordController = TextEditingController();
  TextEditingController _MeanController = TextEditingController();
  TextEditingController _SentenceController = TextEditingController();
  bool _isWordLabelVisible = true;
  bool _isMeanLabelVisible = true;
  bool _isSentenceLabelVisible = true;

  _AddVoca({required this.selectedFileName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(
            color: Color(0xffaaaaaa),
            width: 1,
          ),
          ),
          backgroundColor: backColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text(
            'add_voca',
            style: TextStyle(fontSize: 28),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.asset(
                'images/logo.png', // 로고 이미지의 경로
                width: 70, // 로고 이미지의 폭 조정
                height: 70, // 로고 이미지의 높이 조정
              ),
            ),
          ],
        ),
        body: Container(
          // width: double.infinity, // 가로 꽉차게 설정
          decoration: BoxDecoration(
            color: backColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _WordController,
                                onChanged: (text) {
                                  setState(() {
                                    _isWordLabelVisible = text.isEmpty; // 입력이 비어있으면 라벨을 보여줌
                                    word = _WordController.text;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: _isWordLabelVisible ? 'Word' : '',
                                  labelStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _MeanController,
                                onChanged: (text) {
                                  setState(() {
                                    _isMeanLabelVisible = text.isEmpty; // 입력이 비어있으면 라벨을 보여줌
                                    mean = _MeanController.text;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: _isMeanLabelVisible ? 'Mean' : '',
                                  labelStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _SentenceController,
                                onChanged: (text) {
                                  setState(() {
                                    _isSentenceLabelVisible = text.isEmpty; // 입력이 비어있으면 라벨을 보여줌
                                    sentence = _SentenceController.text;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: _isSentenceLabelVisible ? 'Sentence' : '',
                                  labelStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 110,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xffd6d6d6),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: addVocabularyToJsonFile,
                          child: Text(
                            "단어 추가",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 30,
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(currentBranch: 1),
      ),
    );
  }

  void addVocabularyToJsonFile() async {
    Voca voca = Voca(word: word, mean: mean, sentence: sentence);

    // 현재 파일 경로로 수정할 것
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$selectedFileName.json');

    String fileContent = file.readAsStringSync();
    Map<String, dynamic> fileMap = jsonDecode(fileContent);

    print(fileMap); // 이전 내용 확인하기

    fileMap['words'].add(voca.toJson());

    await file.writeAsString(jsonEncode(fileMap));

    Navigator.pop(context);
  }
}