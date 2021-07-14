import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  CameraFeed(this.cameras, this.setRecognitions);

  @override
  _CameraFeedState createState() => new _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  CameraController camControl;
  bool isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    print(widget.cameras);
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('Walang mahanap na camera sorry pre...');
    } else {
      camControl = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      camControl.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        camControl.startImageStream((CameraImage img) {
          if (!isAnalyzing) {
            isAnalyzing = true;
            Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              model: "SSDMobileNet",
              imageHeight: img.height,
              imageWidth: img.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 3,
              threshold: 0.4,
            ).then((recognitions) {
              widget.setRecognitions(recognitions, img.height, img.width);
              isAnalyzing = false;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    camControl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (camControl == null || !camControl.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var phoneScreenHeight = math.max(tmp.height, tmp.width);
    var phoneScreenWidth = math.min(tmp.height, tmp.width);
    tmp = camControl.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = phoneScreenHeight / phoneScreenWidth;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight: screenRatio > previewRatio
          ? phoneScreenHeight
          : phoneScreenWidth / previewW * previewH,
      maxWidth: screenRatio > previewRatio
          ? phoneScreenHeight / previewH * previewW
          : phoneScreenWidth,
      child: CameraPreview(camControl),
    );
  }
}
