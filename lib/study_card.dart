import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/result_5item_widget.dart';
import 'widgets/sentenceResultStreamWidget.dart';
import 'widgets/voca2.dart';
import 'widgets/my_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'widgets/voca.dart';

var backColor = Color(0xffeeebeb);

class StudyCard extends StatefulWidget {
  String fileName = '';

  StudyCard({Key? key, required this.fileName}) : super(key: key);
  @override
  _StudyCardState createState() => _StudyCardState(selectedFileName: fileName);
}

class _StudyCardState extends State<StudyCard> {
  List<dynamic> vocaList = [];
  String selectedFileName = '';

  final TextEditingController t_controller = TextEditingController();

  _StudyCardState({required this.selectedFileName});

  PageController p_controller = PageController();
  late bool correct;
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    p_controller.addListener(onPageChanged);
    _loadJsonData();
  }
  void onPageChanged() {
    // 페이지 변경이 감지되면 호출되는 함수
    print("Page changed: ${p_controller.page}");
    isSelect = false; // 보기단어 선택여부를 false로 초기화
  }

  Future<void> _loadJsonData() async {
    final directory = await getApplicationDocumentsDirectory(); // 앱 문서 디렉토리 경로 가져오기
    //print("문서 디렉토리 경로: ${directory.path}");
    final file = File('${directory.path}/$selectedFileName.json'); // 파일 객체 생성

    if (!file.existsSync()) file.writeAsString('{"words": []}');
    final String jsonString = await file.readAsString();
    print(jsonString);
    // JSON 문자열을 Map으로 파싱
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // "words" 키에 해당하는 리스트 추출
    vocaList = jsonData['words'];

    // 출력
    print(vocaList);

    setState(() { // vocaList 의 sentence 키 를 지우고 항목을 섞기
      for (var i in vocaList) {
        i.remove('sentence');
      }
      vocaList.shuffle();
      print(vocaList);
    });
  }

  void itemCheck(bool isItemCorrect) {
    correct = isItemCorrect;
    print(correct);
    isSelect = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: backColor,

          appBar: AppBar(
            shape: Border(bottom: BorderSide(
              color: Color(0xffaaaaaa),
              width: 1,
            ),
            ),
            backgroundColor: backColor,

            title: Row(
              children: [
                SizedBox(width: 15,),
                Text(
                  'study card',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
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
          body: PageView.builder(
            controller: p_controller,
            itemBuilder: (context, position) {
              // 페이지마다 다른 색상 정의
              Color backgroundColor = Colors.green.withBlue((255 * (position/vocaList.length)).toInt()).withOpacity(0.8);

              return Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        children: [
                          TextSpan(
                            text: " Q. ",
                          ),
                          TextSpan(
                            text: '${position + 1}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(" 보기 중 빈칸에 들어갈 가장 적절한 단어는?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500), ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      height: 150,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SentenceResultStreamWidget(answer: Voca2(word: vocaList[position]['word'], meaning: vocaList[position]['meaning']), selectedFileName: "complete"),
                    ),
                    SizedBox(height: 15,),
                    Result5ItemsWidget(answer: Voca2(word: vocaList[position]['word'], meaning: vocaList[position]['meaning']),
                      onItemSelected: itemCheck, // 콜백 함수 전달
                    ),
                    //
                    Spacer(),
                    Align(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isSelect == false) {
                            Fluttertoast.showToast(
                              msg: "선택하지 않았습니다.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white, // 텍스트 색상 설정
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: correct
                                  ? "정답!\n ${vocaList[position]['word']} : ${vocaList[position]['meaning']} "
                                  : "오답!",
                              toastLength: Toast.LENGTH_SHORT,
                              // 토스트 메시지 표시 시간 설정
                              gravity: ToastGravity.BOTTOM,
                              // 토스트 메시지의 위치 설정
                              backgroundColor: correct ? Colors.green : Colors
                                  .red,
                              // 배경색 설정
                              textColor: Colors.white, // 텍스트 색상 설정
                            );
                          }
                        },
                        child: Text('정답 확인', style: TextStyle(fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Align(
                      child: Text("${position+1} / ${vocaList.length}", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              );
            },
            itemCount: vocaList.length, // 총 페이지 수
          ),
          bottomNavigationBar: MyBottomNavigationBar(currentBranch: 2),
        )
    );
  }
}

// vocaList[position] 에 해당하는 Voca2 객체 하나 만들어서 sentenceResultStreamWidget() 의 인수로 넣기