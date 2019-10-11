import 'dart:io';
import 'dart:ui' as ui;

import 'package:face_try/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_saver/image_picker_saver.dart' as prefix0;
import 'package:toast/toast.dart';




void main() => runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
//        home: FacePage(),
        home: MyHomePage()
//          title: 'testc crop',
//        ),
//        home: ImageCrop(),
      ),
    );

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (_imageFile == null)
              ? Center(child: Text('No image selected'))
              : Center(
                  child: FittedBox(
                    child: SizedBox(
                      width: _image.width.toDouble(),
                      height: _image.height.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(_image, _faces),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;

  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {

    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
      print(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
    canvas.drawRect(Rect.fromLTRB(300.0, 200.0, 900.0, 800), paint);

  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}

class ImageCrop extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    Image photo = Image.asset('assets/images/test_image.jpg');
//    Img.copyCrop(photo, 100, 80, 150, 150);
//    Img.Image image = Img.decodeJpg(File('test.jpg').readAsBytesSync());

//    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    return Scaffold(
      appBar: AppBar(title: Text('imageTest'),),
      body: Container(
//        child: FutureBuilder(
////            future: ,
//        ),
      ),
    );
  }
}
