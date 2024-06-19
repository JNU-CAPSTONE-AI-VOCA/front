import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'study_card.dart';
import 'dart:io';
import 'widgets/my_bottom_bar.dart';

var backColor = Color(0xffeeebeb);

class Study extends StatefulWidget {
  @override
  _Study createState() => _Study();
}

class _Study extends State<Study> {
  String selectedFile = '          ';

  void selectFile() async { // 버튼 누르면 호출
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/VOCA_LIST.json');
    String fileContent = file.readAsStringSync();
    print(fileContent); // 파일 내용 확인
    List<dynamic> vocaLists = await jsonDecode(fileContent)['vocalist'].where((vocaList) => vocaList != "complete").toList();
    // 저장할 단어장 선택 로직
    selectedFile = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('학습할 단어장을 선택해주세요'),
          content: SingleChildScrollView(
            child: ListBody(
              children: vocaLists.map((vocaList) {
                return ListTile(
                  title: Text(vocaList),
                  onTap: () {
                    Navigator.of(context).pop(vocaList); // 다이얼로그 닫기
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    print('Selected Item: $selectedFile');
    setState(() {
    });
  }

  Future<bool> isEmptyFile(String selectedFile) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$selectedFile.json');
    return (file.readAsStringSync().replaceAll(" ", "") == '{"words":[]}');
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
                  'study',
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
    // Container(
    // margin: EdgeInsets.all(20),
    // width: double.infinity,
    // decoration: BoxDecoration(
    // color: Colors.white,
    // borderRadius: BorderRadius.circular(20),
    // ),
          body: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text(
                    "단어장으로 예문을 만들어 문제를 출제합니다.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff777777),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 30,),
                            Image.asset(
                              'images/study.png',
                              height: 180, // 로고 이미지의 높이 조정
                            ),
                          ],
                        ),

                        Text("예문은\n'학습한 단어들' + '학습할 단어 1개' 로 만들어집니다.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff777777),
                            ),
                            textAlign: TextAlign.center),
                        SizedBox(height: 20,),
                        TextButton(
                          onPressed: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 330, // 모달 높이 크기
                                  margin: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 40,
                                  ), // 모달 좌우하단 여백 크기
                                  padding: EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white, // 모달 배경색
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20), // 모달 전체 라운딩 처리
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("학습한 단어", style: TextStyle(color: Colors.green, height: 1.5)),
                                        Text(": adapt, benefit, efficiency, opportunity, growth", style: TextStyle(color: Colors.green, height: 1.5)),
                                        Text("학습할 단어", style: TextStyle(color: Colors.orange,  height: 1.5)),
                                        Text(": diverse", style: TextStyle(color: Colors.orange,  height: 1.5)),
                                        SizedBox(height: 8,),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(color: Colors.black, height: 1.2, fontWeight: FontWeight.w400),
                                            children: [
                                              TextSpan(text: "예문 : By "),
                                              TextSpan(
                                                text: "adapting ",
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              TextSpan(
                                                text: 'to new technologies, the company ',
                                              ),
                                              TextSpan(
                                                text: 'benefited ',
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              TextSpan(
                                                text: 'from increased ',
                                              ),
                                              TextSpan(
                                                text: 'efficiency ',
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              TextSpan(
                                                text: 'and ',
                                              ),
                                              TextSpan(
                                                text: 'diverse',
                                                style: TextStyle(color: Colors.transparent, decoration: TextDecoration.underline,
                                                  decorationColor: Colors.orange, // 밑줄 색상을 검정으로 설정
                                                  decorationThickness: 1.5, // 밑줄 두께 설정
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' opportunities ',
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              TextSpan(
                                                text: 'for ',
                                              ),
                                              TextSpan(
                                                text: 'growth',
                                                style: TextStyle(color: Colors.green),
                                              ),
                                              TextSpan(
                                                text: '.',
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Text("Q. 빈칸에 들어갈 단어로 적절한것은?"),
                                        SizedBox(height: 5,),
                                        Text("1. divulge"),
                                        Text("2. divert"),
                                        Text("3. divine"),
                                        Text("4. divest"),
                                        Text("5. diverse"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
                            );
                          },
                          child: Text("ⓘ 생성 예시"),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffd9d9d9),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextButton(
                          onPressed: selectFile,
                          child: Text("단어장 선택"),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ],
              ),
              //
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("선택된 단어장 :    "),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xffCCCCCC),
                      ),
                    ),
                    child: Center(
                      child: Text('$selectedFile'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  if (selectedFile != '          ') {
                    if (await isEmptyFile(selectedFile)) {
                      Fluttertoast.showToast(
                        msg: "단어장에 단어가 '한 개' 이상 존재해야 합니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white, // 텍스트 색상 설정
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudyCard(fileName: selectedFile),
                        ),
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "단어장을 선택하지 않았습니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white, // 텍스트 색상 설정
                    );
                  }
                },
                child: Text(
                  "학습하기",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          bottomNavigationBar: MyBottomNavigationBar(currentBranch: 2),
        )
    );
  }
}