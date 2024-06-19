import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';
import 'resultStreamScreen.dart';
import 'camera_screen.dart';
import 'widgets/my_bottom_bar.dart';

var backColor = Color(0xffeeebeb);

class UploadPDF extends StatefulWidget {
  @override
  _UploadPDFState createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  late var selectedPDF; // 선택할 pdf 파일
  late List<int> fileBytes = selectedPDF.files.single.bytes!;
  String fileName = '';
  bool isPdf = true;
  List<dynamic> jsonData = [];

  // 휴대폰에서 PDF 파일 선택하기
  Future<void> _openFileExplorer() async {
    try {
      // 파일 선택 다이얼로그 열기
      selectedPDF = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpg'],
          withData: true
        // allowMultiple: true, // 여러 파일 선택 허용
      );
      if (selectedPDF != null) {
        // 선택된 파일의 바이트
        print(selectedPDF.files);
        fileBytes = selectedPDF.files.single.bytes!;

        print(selectedPDF.names[0]);
        setState(() {
          fileName = selectedPDF.names[0];
          isPdf = ("pdf" == fileName.split('.').last.toLowerCase());
        });

        // await _uploadFile(fileBytes);
      } else {
        print('파일을 선택하지 않았습니다.');
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  // 선택된 파일을 서버로 POST
  Future<void> _uploadFile() async {
    try {
      List<int> fileBytes = selectedPDF.files.single.bytes!;
      // dio 클라이언트 생성
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = "Multipart/form-data";
      // 파일 업로드용 FormData 생성
      FormData formData = FormData.fromMap({
        'files': MultipartFile.fromBytes(fileBytes, filename: 'pdf_file.pdf'), // pdf 본래 이름으로 보내기
      });
      // 파일을 서버로 POST
      var response = await dio.post(
        'http://10.0.2.2:8080/api/files/extract/words', // 휴대폰의 포트/api
        data: formData,
      );
      // ProgressDialog를 사용하여 파일 업로드를 비동기적으로 진행

      // 서버 응답 확인
      if (response.statusCode == 200) {
        print('파일 업로드 성공!');
        jsonData = response.data; // 서버 응답 json 데이터

      } else {
        print('파일 업로드 실패 - HTTP 오류 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('파일 업로드 중 오류 발생: $e');
    }
  }


  Future<void> _openCamera() async {
    final imageFile = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    if (imageFile != null) {
      final pickedFile = PlatformFile(
        name: imageFile.path.split('/').last,
        path: imageFile.path,
        bytes: imageFile.readAsBytesSync(),
        size: imageFile.lengthSync(),
      );

      selectedPDF = FilePickerResult([pickedFile]);

      setState(() {
        fileBytes = pickedFile.bytes!;
        fileName = pickedFile.name;
        isPdf = false; // 이미지는 PDF가 아님
      });
    }
  }

  Future<void> showProgress() async {
    List<int> fileBytes = selectedPDF.files.single.bytes!;
    // 페이지 이동 로직
    Navigator.push(
      context,
      MaterialPageRoute(

        builder: (context) => ResultStreamScreen(data: fileBytes, fileName: fileName),
      ),
    );
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
                'upload',
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
        body: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "영문 pdf, 이미지에서 단어와 예문을 추출합니다",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff777777),
                          ),
                        ),
                        Container(
                          height: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                "images/upload.png",
                                height: 180,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "pdf 혹은 image 파일을 업로드하세요",
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff666666)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: _openFileExplorer,
                                    child: Column(
                                      children: [
                                        Icon(Icons.folder_open, size: 30, color: Colors.green,),
                                        Text('찾기', style: TextStyle(fontSize: 12, color: Colors.grey[700]),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  TextButton(
                                    onPressed: _openCamera,
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_alt_outlined, size: 30, color: Colors.green,),
                                        Text('카메라', style: TextStyle(fontSize: 12, color: Colors.grey[700]),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 100,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xffCCCCCC), //////
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 78,
                                child: Center(
                                  child: Image.asset(
                                    isPdf ? "images/pdf.png" : "images/image.png",
                                    height: 65,
                                  ),
                                ),
                              ),
                              Container(
                                color: Color(0xffCCCCCC),
                                height: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '$fileName',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff666666),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                            onPressed: showProgress,
                            child: Text(
                              "업로드",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(currentBranch: 0),
      ),
    );
  }
}
