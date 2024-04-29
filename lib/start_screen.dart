import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';  // 이 부분은 메인 화면으로 넘어갈 페이지를 임포트합니다.

class StartScreen extends StatefulWidget {
  @override
  _StartScreen createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage())); // 로그인 페이지로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/logo.png', // 로고 이미지 경로
          width: 200, // 이미지 폭 설정
          height: 200, // 이미지 높이 설정
          fit: BoxFit.contain, // 이미지가 비율을 유지하며 전체 공간을 채우도록 설정
        ),
      ),
    );
  }
}