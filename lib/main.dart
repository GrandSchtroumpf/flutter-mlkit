import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './get_total.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: ImageClass(),
      ),
    );
  }
}


class ImageClass extends StatelessWidget {
  final StorageReference storage = FirebaseStorage.instance.ref();
  final CollectionReference collection = Firestore.instance.collection('receipts');

  Future _uploadImage(File image) async {
    // ML
    final date = DateTime.now();
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionImage = FirebaseVisionImage.fromFile(image);
    final result = await textRecognizer.processImage(visionImage);
    // final total = getTotal(result.text);
    // Storage
    final storageRef = this.storage.child('test/${date.toUtc()}');
    final downloadUrl = await storageRef.putFile(image).onComplete;
    final url = await downloadUrl.ref.getDownloadURL();
    print('Url : $url');
    // Firestore
    this.collection.document().setData({
      'url': url,
      'text': result.text,
      // 'total': total,
      'date': date
    });
  }

  Future _fromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this._uploadImage(image);
  }

  Future _fromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this._uploadImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          onPressed: this._fromGallery,
          child: Text('Upload an picture')
        ),
        FlatButton(
          onPressed: this._fromCamera,
          child: Text('Take a picture'),
        )
    ]);
  }
}