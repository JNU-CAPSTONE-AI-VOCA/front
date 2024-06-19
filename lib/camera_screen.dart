import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

var backColor = Color(0xffeeebeb);

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath);

      setState(() {
        _image = File(imagePath);
      });

      Navigator.pop(context, _image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: backColor,
        title: Text('Camera'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: Icon(Icons.camera),
      ),
    );
  }
}