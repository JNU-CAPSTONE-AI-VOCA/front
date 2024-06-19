import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'widgets/my_bottom_bar.dart';
import 'widgets/voca.dart';
import 'widgets/voca2.dart';
import 'package:dio/dio.dart';
import 'add_voca.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'widgets/korean_include_dialog.dart';

var backColor = Color(0xffeeebeb);

class JsonScreen extends StatefulWidget {
  String fileName = '';

  JsonScreen({Key? key, required this.fileName}) : super(key: key);

  @override
  _JsonScreenState createState() =>
      _JsonScreenState(selectedFileName: fileName);
}

class _JsonScreenState extends State<JsonScreen> {
  List<dynamic> vocaList = [];
  String selectedFileName = '';
  // 받은 단어장 이름 (메인 페이지에서 저장한 단어장파일이름으로 대체해야됨)
  // 그 전 페이지에서 사용한 변수를 사용할 수 있으면 없애도 되는 줄
  _JsonScreenState({required this.selectedFileName});
  bool show = false;

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

  // 단어 삭제를 위한 함수
  void _deleteItem(Voca voca, int index) async {
    // 단어장 파일 가져와서 읽기
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$selectedFileName.json');
    String jsonContent = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonContent);
    //단어 삭제
    jsonData['words'].removeAt(index);
    // 삭제한 단어가 적용되게 해당 단어장 json 파일 덮어쓰기
    final updatedJsonString = json.encode(jsonData);
    print(updatedJsonString);
    await file.writeAsString(updatedJsonString);

    setState(() {
      // ui에서 단어 삭제
      vocaList.remove(voca);
    });
  }

  // 단어를 복사해 다른 단어장에 추가하는 함수
  void _copyItem(Voca voca, int indexx) async {
    final directory = await getApplicationDocumentsDirectory();
    File vocaListFile = File('${directory.path}/VOCA_LIST.json');

    String fileContent = vocaListFile.readAsStringSync();
    print(fileContent); // 파일 내용 확인
    List<dynamic> vocaLists = await jsonDecode(fileContent)['vocalist'];

    String selectedFile = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('단어를 복사해 넣을 단어장을 선택해주세요'),
          content: SingleChildScrollView(
            child: ListBody(
              children: vocaLists.map((vocaList) {
                return ListTile(
                  title: Text(vocaList),
                  onTap: () {
                    Navigator.of(context).pop(vocaList);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    File origin_file = File('${directory.path}/$selectedFileName.json');
    String jsonContent = await origin_file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonContent);

    File file = File('${directory.path}/$selectedFile.json');
    String jsonContent2 = await file.readAsString();
    Map<String, dynamic> jsonData2 = jsonDecode(jsonContent2);
    jsonData2['words'].add(jsonData['words'][indexx]);
    print("s: $indexx");

    final updatedJsonString = json.encode(jsonData2);
    print(updatedJsonString);
    await file.writeAsString(updatedJsonString);
  }

  // 단어를 다른 단어장에 이동시키는 함수
  void _moveItem(Voca voca, int index) async {
    final directory = await getApplicationDocumentsDirectory();
    File vocaListFile = File('${directory.path}/VOCA_LIST.json');

    String fileContent = vocaListFile.readAsStringSync();
    print(fileContent); // 파일 내용 확인
    List<dynamic> vocaLists = await jsonDecode(fileContent)['vocalist'];

    String selectedFile = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('단어를 복사해 넣을 단어장을 선택해주세요'),
          content: SingleChildScrollView(
            child: ListBody(
              children: vocaLists.map((vocaList) {
                return ListTile(
                  title: Text(vocaList),
                  onTap: () {
                    Navigator.of(context).pop(vocaList);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    // 현재 단어장
    File origin_file = File('${directory.path}/$selectedFileName.json');
    String jsonContent = await origin_file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonContent);

    // 선택한 단어장
    File file = File('${directory.path}/$selectedFile.json');
    String jsonContent2 = await file.readAsString();
    Map<String, dynamic> jsonData2 = jsonDecode(jsonContent2);

    jsonData2['words'].add(jsonData['words'][index]);
    jsonData['words'].removeAt(index);

    final updatedJsonString1 = json.encode(jsonData);
    final updatedJsonString2 = json.encode(jsonData2);

    await origin_file.writeAsString(updatedJsonString1);
    await file.writeAsString(updatedJsonString2);

    setState(() {
      vocaList.remove(voca);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              color: Color(0xffaaaaaa),
              width: 1,
            ),
          ),
          backgroundColor: backColor,
          title: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                '$selectedFileName',
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
                            return Slidable(
                              key: ValueKey(vocaList[index].word),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) =>
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 150,
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  //안에 들어갈 아이템 추가
                                                  Text(
                                                    "\n단어를 삭제하시겠습니까?",
                                                    style: TextStyle(
                                                      fontSize:
                                                      15.0, // 원하는 폰트 크기로 설정
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        _deleteItem(
                                                            vocaList[index], index);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("예")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 모달 닫기
                                                      },
                                                      child: Text("아니요"))
                                                ],
                                              ),
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) =>
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 150,
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  //안에 들어갈 아이템 추가
                                                  Text(
                                                    "\n단어를 복사하시겠습니까?",
                                                    style: TextStyle(
                                                      fontSize:
                                                      15.0, // 원하는 폰트 크기로 설정
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        _copyItem(
                                                            vocaList[index], index);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("예")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 모달 닫기
                                                      },
                                                      child: Text("아니요"))
                                                ],
                                              ),
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.copy,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) =>
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 150,
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  //안에 들어갈 아이템 추가
                                                  Text(
                                                    "\n단어를 이동시키겠습니까?",
                                                    style: TextStyle(
                                                      fontSize:
                                                      15.0, // 원하는 폰트 크기로 설정
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        _moveItem(
                                                            vocaList[index], index);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("예")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 모달 닫기
                                                      },
                                                      child: Text("아니요"))
                                                ],
                                              ),
                                            );
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.move_up,
                                    label: 'Move',
                                  ),
                                ],
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 60.0,
                                margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffCCCCCC),
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Row(children: [
                                  Flexible(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        vocaList[index].word,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xffCCCCCC),
                                    width: 1.2,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        vocaList[index].meaning,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xffCCCCCC),
                                    width: 1.2,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Center(
                                      child: TextButton(
                                          child: Text('예문 보기'),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ExampleDialog(
                                                    sentence: vocaList[index]
                                                        .sentence,
                                                    fileName: selectedFileName,
                                                    index: index,
                                                  );
                                                });
                                            setState(() {
                                              _loadJsonData();
                                            });
                                          }),
                                    ),
                                  ),
                                ]),
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