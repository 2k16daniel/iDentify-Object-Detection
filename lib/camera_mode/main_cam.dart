import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/utils/drawBox.dart';
import 'package:object_detection/camera_mode/CamModel.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions;
  int _picH = 0;
  int _picW = 0;
  initCameras() async {}
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/model.tflite",
      labels: "assets/models/metadata.txt",
    );
  }

  setRecognitions(recognitions, picHeight, picWidth) {
    setState(() {
      _recognitions = recognitions;
      _picH = picHeight;
      _picW = picWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();
  }

  @override
  Widget build(BuildContext context) {
    Size phoneScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(195, 211, 155, 1),
        title: Text("iDentify @Real Time Mode"),
      ),
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          drawBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_picH, _picW),
            math.min(_picH, _picW),
            phoneScreen.height,
            phoneScreen.width,
          ),
        ],
      ),
    );
  }
}
