import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    // 사용자가 입력한 정보를 검증
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      setState(() => _isLoading = true); // 로딩 시작

      // 예시로 2초 대기
      await Future.delayed(Duration(seconds: 2));

      // 로그인 로직이 성공적으로 완료되었다고 가정하고
      // InputDemo로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InputDemo()),
      );
    } else {
      // 사용자에게 에러 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? SpinKitFadingCircle(
            color: Colors.green,
            size: 50.0,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                width: 129,
                height: 72,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 50),
              // 아이디 입력 필드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '아이디',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // 비밀번호 입력 필드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80), // 입력 필드와 버튼 사이 간격
              // 로그인 버튼
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: Text('로그인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xD6D6D6), // 버튼 배경 색상
                  foregroundColor: Colors.white, // 버튼 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(150, 40), // 버튼 크기
                ),
              ),
              SizedBox(height: 10), // 버튼과 링크 사이 간격
              // 회원가입 링크
              TextButton(
                onPressed: () {
                  // 회원가입 페이지로 네비게이트
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(color: Colors.green), // 링크 텍스트 색상
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}