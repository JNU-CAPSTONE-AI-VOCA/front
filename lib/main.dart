import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadPDF(),
    );
  }
}

class UploadPDF extends StatefulWidget {
  @override
  _UploadPDFState createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  Future<void> _openFileExplorer() async {
    try {
      // 파일 선택 다이얼로그 열기
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
        withData: true
        // allowMultiple: true, // 여러 파일 선택 허용
      );
      if (result != null) {
        // 선택된 파일의 바이트
        print(result.files);
        List<int> fileBytes = result.files.single.bytes!;

        print(fileBytes.length);

        // 선택된 파일을 서버로 POST
        await _uploadFile(fileBytes);//
      } else {
        print('파일을 선택하지 않았습니다.');
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  Future<void> _uploadFile(List<int> fileBytes) async {
    try {
      // dio 클라이언트 생성
      Dio dio = Dio();

      dio.options.headers['Content-Type'] = "Multipart/form-data";
      // 파일 업로드용 FormData 생성
      FormData formData = FormData.fromMap({
        'files': MultipartFile.fromBytes(fileBytes, filename: 'pdf_file.pdf'),
      });

      // 파일을 서버로 POST
      var response = await dio.post(
        'localhost:8080/pdf/upload',
        data: formData,
      );

      // 서버 응답 확인
      if (response.statusCode == 200) {
        print('파일 업로드 성공!');
      } else {
        print('파일 업로드 실패 - HTTP 오류 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('파일 업로드 중 오류 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF 업로드'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _openFileExplorer,
              child: Text('PDF 파일 선택'),
            ),
            SizedBox(height: 20),
                Text('파일을 선택하세요.'),
          ],
        ),
      ),
    );
  }
}
