import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/my_bottom_bar.dart';
import 'widgets/voca.dart';
import 'voca_list.dart';

var backColor = Color(0xffeeebeb);

Map<String, dynamic> saveFile = {};
List<dynamic> words = [];
Map<String, dynamic> word = {};

class VocabularyListScreen extends StatefulWidget {
  final List<dynamic> data;

  VocabularyListScreen({Key? key, required this.data}) : super(key: key);

  @override
  _VocabularyListScreenState createState() => _VocabularyListScreenState(jsonData: data);
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  List<dynamic> jsonData = [];

  _VocabularyListScreenState({required this.jsonData});
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    print(jsonData.toString());
    print(jsonData.runtimeType);

    setState(() {
      // jsonData 에 단어 마다 'isChecked': false 라는 key:value 생성
      for (var i in jsonData) {
        for (var j in i['words']) {
          j['isChecked'] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'result',
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
        color: backColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // 부모 ListView에 스크롤을 맡김
                          itemCount: jsonData.length,
                          itemBuilder: (context, i) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${jsonData[i]['sentence']}", style: TextStyle(fontSize: 16),),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(), // 부모 ListView에 스크롤을 맡김
                                  itemCount: jsonData[i]['words'].length,
                                  itemBuilder: (context, j) {
                                    final word = jsonData[i]['words'][j]['word'];
                                    final mean = jsonData[i]['words'][j]['meaning'];
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text("$word"),
                                          ),
                                          Expanded(
                                            child: Text("$mean"),
                                          )
                                        ],
                                      ),
                                      leading: Checkbox(
                                        value: jsonData[i]['words'][j]['isChecked'],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value ?? false) {
                                              // selectedData 에 해당 wordItem 이 없다면
                                              jsonData[i]['words'][j]['isChecked'] = true;
                                            } else {
                                              // 있다면
                                              jsonData[i]['words'][j]['isChecked'] = false;
                                            }
                                            print(jsonData[i]['words'][j]['isChecked']);
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
      bottomNavigationBar: MyBottomNavigationBar(currentBranch: 0),
    );
  }

  void addVocabularyToJsonFile() async { // 버튼 누르면 호출
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/VOCA_LIST.json');
    // await file.writeAsString('{"vocalist": []}');

    String fileContent = file.readAsStringSync();
    print(fileContent); // 파일 내용 확인
    List<dynamic> vocaLists = await jsonDecode(fileContent)['vocalist'];

    // 저장할 단어장 선택 로직
    String selectedFile = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('저장할 단어장을 선택해주세요'),
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
    print('Selected Item: $selectedFile');

    // VOCA_LIST.json -> test1.json // 단어장 들.json -> 단어장1.json
    file = File('${directory.path}/$selectedFile.json');

    // file.writeAsString(''); // 파일 내용 없애는 코드

    if (!file.existsSync()) { // 파일이 없으면
      await file.writeAsString('{"words":[]}');
    }

    if (file.existsSync()) {
      String fileContent = file.readAsStringSync();
      print(fileContent.toString()); // 기존 파일 내용 읽기

      // 파일에 선택 단어 추가 로직
      Map<String, dynamic> fileMap = json.decode(fileContent);
      for (var i in jsonData) { // 선택 정보를 담게된 jsonData
        for (var j in i['words']) {
          if (j['isChecked']) { // 체크된 항목이라면
            // 주의 : 서버에서 받은 데이터는 meaning 이고 우리는 mean 으로 사용할 것임
            Voca voca = Voca(word: j['word'], meaning: j['meaning'], sentence: i['sentence']); // {word, mean, sentence}
            fileMap['words'].add(voca); // 리스트에 추가함, 아직 파일에 쓰지는 않았음
          }
        }
      }
      await file.writeAsString(jsonEncode(fileMap)); // 내용 추가한 채로 파일에 덮어 쓰기

      print(file.readAsStringSync()); // 잘 덮어 써 졌는지 검증 하기

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JsonScreen(fileName: selectedFile),
        ),
      );
    }
  }
}