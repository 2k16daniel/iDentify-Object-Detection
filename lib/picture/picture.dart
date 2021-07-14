import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class StaticImage extends StatefulWidget {
  @override
  _StaticImageState createState() => _StaticImageState();
}

class _StaticImageState extends State<StaticImage> {
  File _picture;
  double _picW, _picH;
  List _identify;
  bool _isBusy;

  final imagePicker = ImagePicker();

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/model.tflite",
      labels: "assets/models/metadata.txt",
    );
  }

  detectObject(File image) async {
    var identify = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "SSDMobileNet",
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.1,
      numResultsPerClass: 5,
    );
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _picW = info.image.width.toDouble();
            _picH = info.image.height.toDouble();
          });
        })));
    setState(() {
      _identify = identify;
    });
  }

  @override
  void initState() {
    super.initState();
    _isBusy = true;
    loadTfModel().then((val) {
      {
        setState(() {
          _isBusy = false;
        });
      }
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_identify == null) return [];
    if (_picW == null || _picH == null) return [];

    double factorX = screen.width;
    double factorY = _picH / _picH * screen.width;

    Color blue = Colors.blue;

    return _identify.map((re) {
      return Container(
        child: Positioned(
            left: re["rect"]["x"] * factorX,
            top: re["rect"]["y"] * factorY,
            width: re["rect"]["w"] * factorX,
            height: re["rect"]["h"] * factorY,
            child: ((re["confidenceInClass"] > 0.50))
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: blue,
                      width: 3,
                    )),
                    child: Text(
                      "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        background: Paint()..color = blue,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  )
                : Container()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      child: _picture == null
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please Select an Image"),
                ],
              ),
            )
          : Container(child: Image.file(_picture)),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_isBusy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(195, 211, 155, 40),
        title: Text("iDentify : Pick from gallery"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Color.fromRGBO(195, 211, 155, 40),
            heroTag: "Fltbtn1",
            child: Icon(Icons.photo),
            onPressed: getImageFromGallery,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _picture = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_picture);
  }

  Future getImageFromGallery() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _picture = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_picture);
  }
}
