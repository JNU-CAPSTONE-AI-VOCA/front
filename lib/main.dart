import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'voca_list.dart';
import 'widgets/my_bottom_bar.dart';
import 'start_screen.dart';

var backColor = Color(0xffeeebeb);

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOCAI',
      home: StartScreen(),
    );
  }
}

class InputDemo extends StatefulWidget {
  @override
  _InputDemoState createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  final voca_nameController = TextEditingController();

  // 버튼 눌렀을 때 해당 단어장 이름을 담는 변수
  String selectedFileName = '';

  @override
  void initState() {
    super.initState();
    repeatListNum();
  }

  // @override
  // void didChangeDependencies() { // repeatListNum 함수를 위젯 build 전에 한번 돌리기 위해 작성한 함수
  //   super.didChangeDependencies();
  //   repeatListNum();
  // }
  //
  // @override
  // void dispose() {
  //   voca_nameController.dispose();
  //   super.dispose();
  // }

  List<Widget> buttonsList = [];

  Future<void> repeatListNum() async{ // 저장된 단어장 목록 읽기
    List<dynamic> li = await readJsonFile(); // VOCA_LIST json파일 읽어오기
    print(li);
    for (int i = 0; i < li.length; i++) {
      savedButton(li[i]);
    }
  }
  // 저장되어있는 단어장 리스트 버튼 생성되게 할 함수
  // 들어가는 위젯이 savedButton 함수랑 addButton 함수랑 같음
  // 시간날 때 코드 길이 줄이기
  void savedButton(String input_text) { // 저장된 단어장 버튼 생성
    Widget newButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          onPressed: () {
            selectedFileName = '$input_text';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JsonScreen(fileName: selectedFileName),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 100),
            backgroundColor: Colors.white,
            // 글자 색상 및 애니메이션 색 설정
            foregroundColor: Colors.black,
            // 글자 그림자 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // 글자 3D 입체감 높이
            textStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            ),
            //padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
          ),
          child: Text(input_text),
        )
    );
    Widget space = SizedBox(height: 10); // 원하는 높이로 조절
    setState(() {
      buttonsList.add(space);
      buttonsList.add(newButton);
    });
  }

  void addButton(String input_text) {
    Widget newButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          onPressed: () {
            selectedFileName = '$input_text';

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JsonScreen(fileName: selectedFileName),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150, 100),
            backgroundColor: Colors.white,
            // 글자 색상 및 애니메이션 색 설정
            foregroundColor: Colors.black,
            // 글자 그림자 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // 글자 3D 입체감 높이
            textStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30.0,
            ),
            //padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
          ),
          child: Text(input_text),
        )
    );
    Widget space = SizedBox(height: 10); // 원하는 높이로 조절
    setState(() {
      buttonsList.add(space);
      buttonsList.add(newButton);
      updateJsonFile('$input_text'); // VOCA_LIST.json 에 생성한 단어장 저장
    });
  }
// 단어장 이름들 담을 json 파일, 단어장 추가할 때마다 함수 불러서 json파일에 적게 함
  Future<void> updateJsonFile(String vocalistname) async {
    // 단어장 목록에 단어장 추가
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/VOCA_LIST.json');
    String jsonContent = await file.readAsString();
    Map<String, dynamic> data = jsonDecode(jsonContent);
    data['vocalist'].add(vocalistname);
    String updatedJsonContent = jsonEncode(data);
    await file.writeAsString(updatedJsonContent);

    // 단어장 추가 확인 코드
    String jsonString2 = file.readAsStringSync();
    print("파일 이름들 담은 json 파일 \n"+jsonString2);

    // 생성한 단어장의 내용을 초기화
    file = File('${directory.path}/$vocalistname.json');
    file.writeAsString('{"words": []}');
  }
// readJsonFile : json파일을 읽어서 vocalist를 반환하는 함수
  Future<List> readJsonFile() async {
    // 1. JSON 파일 읽기
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/VOCA_LIST.json');

    await file.delete(); // 파일 초기화하기

    print('${file.path}\n');
    print(file.path.toString());

    // 파일이 없으면 생성해 주기
    if (!file.existsSync()) {
      file.writeAsString('{"vocalist": []}');
    }

    String jsonContent = await file.readAsString();
    print(jsonContent);
    Map<String, dynamic> data = jsonDecode(jsonContent);

    List<dynamic> return_list = data['vocalist'];

    // 단어장 목록 초기화 시키기
    // file.writeAsString('{"vocalist": []}');
    return return_list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backColor,
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
              'voca list',
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
            width: double.infinity,
            // 가로 꽉차게 설정
            height: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '자신만의 단어장을 \n 만들어보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffB6B1B1),
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: buttonsList.length,
                      itemBuilder: (context, index) {
                        return buttonsList[index];
                        },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(30, 65), // 버튼의 최소 가로, 세로 크기 설정
                        backgroundColor: Colors.white
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context)
                          {
                            // TextEditingController를 사용하여 TextField의 입력값 관리
                            TextEditingController customController = TextEditingController();
                            return AlertDialog(
                              title: Text('단어장 이름 정하기'),
                              content: TextField(
                                controller: customController,
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    addButton(customController.text);
                                    // 여기서 customController.text를 사용하여 입력값 처리
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                    child: Text('+',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.green,
                      ),),
                  ),
                )

              ],
            ), // child: Text('안녕하세요', style: TextStyle( color : Colors.red )),
          ),
          bottomNavigationBar: MyBottomNavigationBar(currentBranch: 1),
        ),
    );
  }
}