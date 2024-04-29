import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'widgets/my_bottom_bar.dart';
import 'voca.dart';
import 'add_voca.dart';

var backColor = Color(0xffeeebeb);

class JsonScreen extends StatefulWidget {
  String fileName = '';

  JsonScreen({Key? key, required this.fileName}) : super(key: key);
  @override
  _JsonScreenState createState() =>
      _JsonScreenState(selectedFileName: fileName);
}

class _JsonScreenState extends State<JsonScreen> {
  List<Voca> vocaList = [];
  String selectedFileName = '';
  // 받은 단어장 이름 (메인 페이지에서 저장한 단어장파일이름으로 대체해야됨)
  // 그 전 페이지에서 사용한 변수를 사용할 수 있으면 없애도 되는 줄
  _JsonScreenState({required this.selectedFileName});

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    final directory =
        await getApplicationDocumentsDirectory(); // 앱 문서 디렉토리 경로 가져오기
    //print("문서 디렉토리 경로: ${directory.path}");
    final file = File('${directory.path}/$selectedFileName.json'); // 파일 객체 생성

    if (!file.existsSync()) file.writeAsString('{"words": []}');
    final String jsonString = await file.readAsString();
    print(jsonString);
    List<dynamic> jsonData = await (json.decode(jsonString))['words'];

    setState(() {
      vocaList = jsonData.map((data) => Voca.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backColor,
        resizeToAvoidBottomInset: false,
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
            '$selectedFileName',
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
          width: double.infinity, // 가로 꽉차게 설정
          child: Column(
            children: [
              Container(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: vocaList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              height: 60.0,
                              margin: EdgeInsets.fromLTRB(10, 3, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffCCCCCC),
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: double.infinity,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                              child:
                                                  Text(vocaList[index].word)),
                                        ),
                                        Container(
                                          color: Color(0xffCCCCCC),
                                          height: 1.2,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                              child:
                                                  Text(vocaList[index].mean)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xffCCCCCC),
                                    width: 1.2,
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(vocaList[index].sentence)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddVoca(fileName: selectedFileName),
                    ),
                  );
                  _loadJsonData();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(40, 50),
                  backgroundColor: Colors.white,
                  // 글자 색상 및 애니메이션 색 설정
                  foregroundColor: Colors.black,
                  // 글자 그림자 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  // 글자 3D 입체감 높이
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                  ),
                ),
                child: Text('+'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(currentBranch: 1),
      ),
    );
  }
}
