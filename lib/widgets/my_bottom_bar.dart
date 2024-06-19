import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../upload.dart';
import '../study.dart';

class MyBottomNavigationBar extends StatelessWidget {
  int currentBranch;

  MyBottomNavigationBar({
    required this.currentBranch,
  });

  List _pages = [
    UploadPDF(),
    InputDemo(),
    Study(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentBranch,
      onTap: (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _pages[value],
          ),
        );
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'upload'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'vocabulary'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book), label: 'study'),
      ],
    );
  }
}
